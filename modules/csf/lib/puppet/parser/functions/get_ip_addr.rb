require 'resolv'

module Puppet::Parser::Functions

  Regex256 = Resolv::IPv4::Regex256
  Regex_bit_mask = /([0-9]|[12][0-9]|3[0-2])/
  RegexCIDR = /\A(#{Regex256})\.(#{Regex256})\.(#{Regex256})\.(#{Regex256})\/(#{Regex_bit_mask})\z/

  newfunction(:get_ip_addr, :type => :rvalue) do |args|
    address = args.first
    if address =~ Resolv::IPv4::Regex || address =~ RegexCIDR
      address
    else
      if address == "any"
        "0.0.0.0/0"
      else
        Resolv::DNS.open { |dns| dns.getaddress(address) }
      end
    end
  end
end
