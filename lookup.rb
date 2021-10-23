def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("./zone")

# ..
# ..
# FILL YOUR CODE HERE
# ..
# ..

def resolve(dns_records, lookup_chain, domain)
  #A Type record , stop recursion
  lookup_chain.push(dns_records[domain][0])
  if dns_records[domain][1] == "A"
    return lookup_chain
  else
    return resolve(dns_records, lookup_chain, dns_records[domain][0])
  end
end

def parse_dns(file)
  records = {}
  for line in file
    if not(line[0] == "#" or line[0].to_s.strip.empty?)
      type, domain, ip = line.strip().split(", ")
      records[domain] = [ip, type]
      #records.push(line.strip().split(", "))
    end
  end
  return records
end

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)

lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
