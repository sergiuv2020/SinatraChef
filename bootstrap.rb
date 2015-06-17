require 'cocaine'
require 'logger'
require 'securerandom'

class KnifeCommands

  @@randomUID = SecureRandom.hex(3)
  @@nodeName = 'ChefNode' + @@randomUID
  def knifeSingleNode(username, password, ipOrHostname)
  	line = Cocaine::CommandLine.new("sleep","10")
    # line = Cocaine::CommandLine.new("knife", "bootstrap #{ipOrHostname} -x #{username} -P #{password} -N #{@@nodeName} > #{@@nodeName}.log && sleep 600")
    line.run
  end

  def deleteClient
    begin
      Cocaine::CommandLine.new("knife", "node delete #{@@nodeName} -y >> #{@@nodeName}.log").run
      Cocaine::CommandLine.new("knife", "client delete #{@@nodeName} -y >> #{@@nodeName}.log").run
    rescue
      puts 'The client you tried to delete does not exist !'
    end
  end

end