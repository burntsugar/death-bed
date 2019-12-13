class String
    def numeric?
      Integer(self) != nil rescue false
    end
  end

class URLParser

    # URLParser
    # 
    # Will parse most commonly found URLs and store each part in a hash.
    # Path segments are seperated into an array for convenience.
    # Querystrings are seperated into a hash for convenience.
    # Does not support IPv6 host names (maybe oneday) - raises StandardError
    # Raises StandardError for non-numeric port numbers.
    # Heaps of comments - pretty ugly. I chose *against* abstracting code into too many methods. The logic to parse the URL is so tightly coupled that it made sense (against all other urges) to keep most it together.    

     def self.decompose_url_parts(url_string)

        url_components = {:url => url_string, :urlparts => 
            {:scheme => "", :authority => {:userinfo => "", :password => "", :host => "", :port => ""},
            :path => {:segments => [], :querystring => {}, :fragment => ""}}
            }
        
        # Starts with the URL and reduces str to its parts.
        str = url_components[:url]

        # Fragment. Optional URL part.
        if str.include?"#" # Has fragment?
            url_components[:urlparts][:path][:fragment] = str.split("#")[1] # Seperate string start, fragment. Assign fragment.
            str = str.split("#")[0] # Remove fragment from str.
        end

        # Querystring. Optional part.
        if str.include?"?" # Has querystring?
            qs = str.split("?")[1].split("&") # Seperate string start, querystring and then seperate key pairs.
            qs.each do |pair|
                url_components[:urlparts][:path][:querystring][pair.split("=")[0].to_sym] = pair.split("=")[1] # Seperate key, value. Assign hash key/value.
            end
            str = str.split("?")[0] # Remove querystring from str.
        end

        # Path. Optional part.
        path_start = "" # Find path start.
        if str.include?("//") # Has authority slashes?
            str_temp = String.new(str) # Copy url.
            str_temp.slice!(/\/\//) # Remove authority slashes
            if str_temp.include?("/") # Has path?
                path_start = str_temp.partition("/")[2] # Set start path to the characters following the slash.
                str = str[0,str.length - (path_start.length + 1)] # Remove path from str.
            end
        else # else has no authority parts, path begins immediately after the colon.
            path_start = str.partition(":")[2] # Set start path to the characters following the colon.
            path_start.slice!(/\//) # Remove any remaining slash from the end of the path.
        end
        path_segments = path_start.split("/") # Get path segments
        path_segments.each do |segment|
            url_components[:urlparts][:path][:segments] << segment
        end

        # Scheme. Required part.
        url_components[:urlparts][:scheme] = str.partition(":")[0]

        # Authority parts.
        if str.include?("//") # Has authority?
            split1 = str.partition("//")
            if split1[2].include?("@") # Has userinfo?
                ui = split1[2].split("@")[0] # Get userinfo from the left of @.
                split_userinfo = ui.split(":")
                url_components[:urlparts][:authority][:userinfo] = split_userinfo[0]
                if split_userinfo.length == 2
                    url_components[:urlparts][:authority][:password] = split_userinfo[1]
                end
                
                remaining = split1[2].split("@")[1] # Get the string to the right of @ which contains host and possibly port.
                if remaining.include? ":" # Has port?
                    port_host = remaining.split(":") # Seperate host, port.
                    if !port_host[1].numeric?
                        raise "Port must be numeric!"
                    end
                    url_components[:urlparts][:authority][:port] = port_host[1] # Assign host.
                    url_components[:urlparts][:authority][:host] = port_host[0] # Assign port.
                else # No port, only host.
                    url_components[:urlparts][:authority][:host] = remaining
                end
            else # No userinfo.
                if split1[2].include? ":"
                    port_host = split1[2].split(":")
                    url_components[:urlparts][:authority][:port] = port_host[1]
                    url_components[:urlparts][:authority][:host] = port_host[0]
                else
                    url_components[:urlparts][:authority][:host] = split1[2]
                end
            end           
        end

        url_components

        end
        private_class_method :decompose_url_parts

        # Decomposes a string url into its parts.
        #
        # @param url [String]
        # @return [Hash] the url decomposed into a parts hash.
        def self.parse(url_string)
            if url_string == nil || url_string.empty?
                raise "Cannot parse nil or empty string!"
            end
            if url_string.count("[]") > 0
               raise "Authority parts containing IPv6 hosts are not supported at this time."
            end
            decompose_url_parts(url_string)
        end

end