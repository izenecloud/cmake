#--
# Author::  Ian Yang
# Created:: <2010-07-27 15:23:33>
#++
#
# For test tasks
require 'rubygems'
require 'rake'
require 'rake/tasklib'
require 'hpricot'
require 'builder'
require 'timeout'
include Rake::DSL

require 'izenesoft/string-patch'

module IZENESOFT

  class BoostTestJUnitReport
    def initialize
      @doc = Hpricot::XML <<XML
<?xml version="1.0" encoding="UTF-8"?>
<testsuites/>
XML
      @root = @doc.root
    end

    def make(xml)
      Hpricot::XML(xml).children
    end

    def add(in_xml)
      in_doc = Hpricot::XML(in_xml)
      properties = make("<properties/>").first
      if buildinfo = in_doc.at("/TestLog/BuildInfo")
        buildinfo.attributes.to_hash.each do |k, value|
          properties[k] = value
        end
      end

      (in_doc/"TestSuite").each do |in_testsuite|
        add_testsuite(in_testsuite, properties)
      end
    end
    alias :<< :add

    def write(stream = STDOUT)
      @doc.output(stream)
    end

    private
    def escape(text)
      return "" if text.nil?

      text.strip!
      limit_length(text)
      replace_invalid_utf8_bytes(text)
      remove_invalid_xml_chars(text)
    end

    MEGA = 1024 * 1024

    def limit_length(text)
      if text.length > MEGA
        text[0, text.length - MEGA] = "[truncated #{text.length - MEGA} chars] "
      end
    end

    # reference from below URL:
    # http://stackoverflow.com/a/8873922
    def replace_invalid_utf8_bytes(text)
      text.encode!('UTF-16', 'UTF-8', :invalid => :replace)
      text.encode!('UTF-8', 'UTF-16')
    end

    # reference from below URL:
    # http://www.w3.org/TR/2000/REC-xml-20001006#charsets
    def remove_invalid_xml_chars(text)
      result = ""
      text.each_char do |char|
        code = char.ord
        if code == 0x9 || code == 0xA || code == 0xD ||
            (code >= 0x20 && code <= 0xD7FF) ||
            (code >= 0xE000 && code <= 0xFFFD) ||
            (code >= 0x10000 && code <= 0x10FFFF)
          result << char
        end
      end
      result
    end

    def add_testsuite(in_testsuite, properties)
      in_testcases = (in_testsuite/"/TestCase")
      return if in_testcases.empty?

      testsuite_fullname = in_testsuite["name"].gsub(".", "_")
      parent = in_testsuite.parent
      while parent and parent.name == "TestSuite"
        testsuite_fullname = parent["name"].gsub(".", "-") + "." + testsuite_fullname
        parent = parent.parent
      end

      testsuite_fullname = testsuite_fullname.gsub(/&[lg]t;/, "_").gsub(/[^._A-Za-z0-9]/, "_")

      testsuite = make("<testsuite/>").first
      @root.children ||= []
      @root.insert_after(testsuite, "*")
      testsuite["name"] = testsuite_fullname
      testsuite["package"] = testsuite_fullname

      errors = 0;
      failures = 0;
      tests = 0;
      time = 0.0;
      testsuite.inner_html = properties.to_html

      in_testcases.each do |in_testcase|
        testcase = make("<testcase/>").first
        testcase.children ||= []
        testsuite.insert_after(testcase, "*")

        testcase["name"] = in_testcase["name"].gsub(/&[lg]t;/, "_").gsub(/[^_A-Za-z0-9]/, "_")

        testcase_time_element = (in_testcase/"TestingTime").remove.first
        testcase_time = testcase_time_element ? testcase_time_element.inner_text.strip.to_i : 0
        testcase_time /= 1000_000.0
        time += testcase_time

        testcase["time"] = testcase_time.to_s

        testcase["classname"] = testsuite_fullname + ".root"
        in_testcase.containers.each do |element|
          if element["file"]
            testcase["classname"] = testsuite_fullname + "." + element["file"].sub(/\.[^.]+$/, "").sub(/^\./, "")
            break
          end
        end

        # Exception is unexpected error
        error = (in_testcase/"Exception").remove.first

        assertion_log = ""
        failure_log = ""
        in_testcase.containers.each do |log_entry|
          next if ["SystemOut", "SystemErr"].include? log_entry.name
          current_log = <<EOF
[#{log_entry.name}] - #{log_entry.inner_text.strip}
 == [File] - #{log_entry["file"]}
 == [Line] - #{log_entry["line"]}

EOF
          assertion_log << current_log
          failure_log << current_log if ["Error", "FatalError"].include? log_entry.name
        end

        at_system_out = in_testcase.at("SystemOut")
        system_out_inner_text = at_system_out && at_system_out.inner_text
        system_out = Hpricot::Tag::CData.new(<<CDATA).to_html
#{assertion_log}
ASSERTION LOG ENDS HERE
#{escape(system_out_inner_text)}
CDATA
        testcase.insert_after(make(<<XML), "*")
<system-out>#{system_out}</system-out>
XML

        at_system_err = in_testcase.at("SystemErr")
        system_err_inner_text = at_system_err && at_system_err.inner_text
        system_err = Hpricot::Tag::CData.new(escape(system_err_inner_text)).to_html
        testcase.insert_after(make(<<XML), "*")
<system-err>#{system_err}</system-err>
XML

        tests += 1
        if error
          errors += 1
          type, message = error.inner_text.strip.split(":", 2)
          checkpoint = error.at("LastCheckpoint")
          body = error.inner_text
          if checkpoint
            body << <<EOF

[Last Check Point]
 == [File] - #{checkpoint["file"]}
 == [Line] - #{checkpoint["line"]}
EOF
          end

          error_element = make("<error/>").first
          testcase.insert_after(error_element, "*")
          error_element["type"] = type
          error_element["message"] = message
          error_element.inner_html = Hpricot::Tag::CData.new(body).to_html
        elsif !failure_log.empty?
          failures += 1
          failure_element = make("<failure/>").first
          testcase.insert_after(failure_element, "*")
          failure_element["type"] = "AssertionFailedError"
          failure_element["message"] = failure_log.split("\n").grep(/^\[/).join
          failure_element.inner_html = Hpricot::Tag::CData.new(failure_log).to_html
        end

      end

      testsuite["tests"] = tests.to_s
      testsuite["errors"] = errors.to_s
      testsuite["failures"] = failures.to_s
      testsuite["time"] = time.to_s

    end
  end

  class BoostTest

    attr_accessor :name
    attr_accessor :test_dir
    attr_accessor :timeout

    def initialize(name = "test")
      @name = name
      @test_dir = "testbin"
      @timeout = 900
      yield self if block_given?
      define
    end

    def xunit_output
      "--output_format=XML --log_level=test_suite --report_level=no"
    end

    def define
      results_dir = File.join(@test_dir, "results")
      tmp_dir = File.join(@test_dir, "tmp")

      directory results_dir
      directory tmp_dir

      desc "Unit Test"
      task name, [:use_xml] => [results_dir, tmp_dir] do |t, args|
        errors = []

        Dir.chdir @test_dir do
          Dir["t_*"].each do |test_exe|
            if File.executable? test_exe
              begin
                Timeout.timeout(@timeout) do
                  begin
                    if args[:use_xml]
                      ENV["BOOST_TEST_LOG_FILE"] = "results/#{test_exe}.xml"
                      sh "./#{test_exe} --build_info #{xunit_output}"
                    else
                      ENV.delete "BOOST_TEST_LOG_FILE"
                      sh "./#{test_exe} --show_progress"
                    end
                  rescue => e
                    # do not report errors because errors are already saved in reports

                    # 201 are boost test failure, ignore it because it has been
                    # added in xml report
                    unless $?.exitstatus == 201
                      errors << [test_exe, e.message]
                    end
                  end
                end
              rescue Timeout::Error => e
                errors << [test_exe, e.message]
              end
            end
          end

          if args[:use_xml] and !errors.empty?
            File.open("results/runner.xml", "w") do |ofs|
              runner_xml_builder = Builder::XmlMarkup.new(:target => ofs)
              runner_xml_builder.TestLog { |xml|
                xml.TestSuite(:name => "TestRunner") {
                  errors.each do |error|
                    xml.TestCase(:name => error[0], :classname => "TestRunner.#{error[0]}") {
                      xml.Exception {
                        xml.cdata! "AbnormalExit: #{error[1]}"
                      }
                      xml.SystemOut {
                        xml.cdata! ""
                      }
                      xml.SystemErr {
                        xml.cdata! ""
                      }
                    }
                  end                
                }
              }
            end
            errors.clear
          end

          if args[:use_xml]
            # to junit report
            junit_report = BoostTestJUnitReport.new
            Dir["results/*.xml"].each do |xml|
              junit_report << File.read(xml)
            end
            File.open("results.xml", "w") do |ofs|
              junit_report.write(ofs)
            end
          end
        end

        raise errors.join("\n") unless errors.empty?

      end

      desc "Unit Test clobber"
      task "#{name}_clobber" do
        Dir[File.join(results_dir, "*")].each do |f|
          rm_rf f
        end
        Dir[File.join(tmp_dir, "*")].each do |f|
          rm_rf f
        end
      end
    end
  end
end
