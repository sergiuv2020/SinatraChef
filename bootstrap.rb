class Bootstrap

  def execute(ipAddress)
    %x(kitchen converge "#{ipAddress}")
  end

end

