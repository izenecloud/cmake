class String
  def shell_escape
    if empty?
      %q|''|
    elsif %r|\A[[:alnum:]+,./:=@_-]*\z| =~ self
      dup
    else
      gsub(/('+)|[^']+/) do
        if $1
          %q|\'| * $1.length
        else
          "'#{$&}'"
        end
      end
    end
  end
end
