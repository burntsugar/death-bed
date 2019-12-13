require 'rspec'
require_relative '../lib/death-bed.rb'


describe URLParser do

    describe '#parse ... ' do
        it 'parses a url containing only a path which ends with a slash' do
            url_string = "foo:filename/"
            expected_url_components = {:url => url_string, :urlparts => 
                {:scheme => "foo", :authority => {:userinfo => "", :password => "", :host => "", :port => ""},
                :path => {:segments => ["filename"], :querystring => {}, :fragment => ""}}
                }
            expect(URLParser.parse(url_string)).to eql(expected_url_components)
        end
    end

    describe '#parse ... ' do
        it 'parses a url containing only a path which ends with a querystring' do
            url_string = "foo:filename?akey=avalue"
            expected_url_components = {:url => url_string, :urlparts => 
                {:scheme => "foo", :authority => {:userinfo => "", :password => "", :host => "", :port => ""},
                :path => {:segments => ["filename"], :querystring => {:akey => "avalue"}, :fragment => ""}}
                }
            expect(URLParser.parse(url_string)).to eql(expected_url_components)
        end
    end

    describe '#parse ... ' do
        it 'parses a url with only a host and no trailing slash' do
            url_string = "foo://example.com"
            expected_url_components = {:url => url_string, :urlparts => 
                {:scheme => "foo", :authority => {:userinfo => "", :password => "", :host => "example.com", :port => ""},
                :path => {:segments => [], :querystring => {}, :fragment => ""}}
                }
            expect(URLParser.parse(url_string)).to eql(expected_url_components)
        end
    end

    describe '#parse ... ' do
        it 'parses a url with only a host and a trailing slash' do
            url_string = "foo://example.com/"
            expected_url_components = {:url => url_string, :urlparts => 
                {:scheme => "foo", :authority => {:userinfo => "", :password => "", :host => "example.com", :port => ""},
                :path => {:segments => [], :querystring => {}, :fragment => ""}}
                }
            expect(URLParser.parse(url_string)).to eql(expected_url_components)
        end
    end

    describe '#parse ... ' do
        it 'parses userinfo with password part' do
            url_string = "foo://user:password@example.com"
            expected_url_components = {:url => url_string, :urlparts => 
                {:scheme => "foo", :authority => {:userinfo => "user", :password => "password", :host => "example.com", :port => ""},
                :path => {:segments => [], :querystring => {}, :fragment => ""}}
                }
            expect(URLParser.parse(url_string)).to eql(expected_url_components)
        end
    end

    describe '#parse ... ' do
        it 'parses userinfo with password part' do
            url_string = "foo://user:password@example.com:8080/my/path"
            expected_url_components = {:url => url_string, :urlparts => 
                {:scheme => "foo", :authority => {:userinfo => "user", :password => "password", :host => "example.com", :port => "8080"},
                :path => {:segments => ["my","path"], :querystring => {}, :fragment => ""}}
                }
            expect(URLParser.parse(url_string)).to eql(expected_url_components)
        end
    end

    describe '#parse ... ' do
        it 'parses userinfo with password part' do
            url_string = "foo://user:password@example.com:8080/?showme=this"
            expected_url_components = {:url => url_string, :urlparts => 
                {:scheme => "foo", :authority => {:userinfo => "user", :password => "password", :host => "example.com", :port => "8080"},
                :path => {:segments => [], :querystring => {:showme => "this"}, :fragment => ""}}
                }
            expect(URLParser.parse(url_string)).to eql(expected_url_components)
        end
    end

    describe '#parse ... ' do
        it 'parses userinfo with password part, another combination' do
            url_string = "foo://user:password@example.com:8080/?showme=this#here"
            expected_url_components = {:url => url_string, :urlparts => 
                {:scheme => "foo", :authority => {:userinfo => "user", :password => "password", :host => "example.com", :port => "8080"},
                :path => {:segments => [], :querystring => {:showme => "this"}, :fragment => "here"}}
                }
            expect(URLParser.parse(url_string)).to eql(expected_url_components)
        end
    end

    describe '#parse ... ' do
        it 'raises an error where the host is an IPv6 address' do
            url_string = "foo://[3:3:3]/"
            expect{URLParser.parse(url_string)}.to raise_error("Authority parts containing IPv6 hosts are not supported at this time.")
        end
    end

    describe '#parse ... ' do
        it 'raises an error where the given port number is not numeric' do
            url_string = "foo://user@example.com:xxx/"
            expect{URLParser.parse(url_string)}.to raise_error("Port must be numeric!")
        end
    end

    describe '#parse ... ' do
        it 'raises an error where the url string is nil' do
            url_string = nil
            expect{URLParser.parse(url_string)}.to raise_error("Cannot parse nil or empty string!")
        end
    end

    describe '#parse ... ' do
        it 'raises an error where the url string is empty' do
            url_string = ""
            expect{URLParser.parse(url_string)}.to raise_error("Cannot parse nil or empty string!")
        end
    end

    describe '#parse ... ' do
        it 'parses another combination' do
            url_string = "foo://user@example.com:8042/over/there?name=ferret&id=f100#nose"
            expected_url_components = {:url => url_string, :urlparts => 
                {:scheme => "foo", :authority => {:userinfo => "user", :password => "", :host => "example.com", :port => "8042"},
                :path => {:segments => ["over","there"], :querystring => {:name => "ferret", :id => "f100"}, :fragment => "nose"}}
                }
            expect(URLParser.parse(url_string)).to eql(expected_url_components)
        end
    end

    describe '#parse ... ' do
        it 'parses another combination' do
            url_string = "foo://example.com:8042/over/there?name=ferret&id=f100#nose"
            expected_url_components = {:url => url_string, :urlparts => 
                {:scheme => "foo", :authority => {:userinfo => "", :password => "", :host => "example.com", :port => "8042"},
                :path => {:segments => ["over","there"], :querystring => {:name => "ferret", :id => "f100"}, :fragment => "nose"}}
                }
            expect(URLParser.parse(url_string)).to eql(expected_url_components)
        end
    end

    describe '#parse ... ' do
        it 'parses another combination' do
            url_string = "foo://example.com/over/there?name=ferret&id=f100#nose"
            expected_url_components = {:url => url_string, :urlparts => 
                {:scheme => "foo", :authority => {:userinfo => "", :password => "", :host => "example.com", :port => ""},
                :path => {:segments => ["over","there"], :querystring => {:name => "ferret", :id => "f100"}, :fragment => "nose"}}
                }
            expect(URLParser.parse(url_string)).to eql(expected_url_components)
        end
    end

    describe '#parse ... ' do
        it 'parses another combination' do
            url_string = "foo://example.com/over?name=ferret&id=f100#nose"
            expected_url_components = {:url => url_string, :urlparts => 
                {:scheme => "foo", :authority => {:userinfo => "", :password => "", :host => "example.com", :port => ""},
                :path => {:segments => ["over"], :querystring => {:name => "ferret", :id => "f100"}, :fragment => "nose"}}
                }
            expect(URLParser.parse(url_string)).to eql(expected_url_components)
        end
    end

    describe '#parse ... ' do
        it 'parses another combination' do
            url_string = "foo://example.com/over?name=ferret&id=f100"
            expected_url_components = {:url => url_string, :urlparts => 
                {:scheme => "foo", :authority => {:userinfo => "", :password => "", :host => "example.com", :port => ""},
                :path => {:segments => ["over"], :querystring => {:name => "ferret", :id => "f100"}, :fragment => ""}}
                }
            expect(URLParser.parse(url_string)).to eql(expected_url_components)
        end
    end

    describe '#parse ... ' do
        it 'parses another combination' do
            url_string = "https://tools.ietf.org/html/rfc3986#section-3.2.1"
            expected_url_components = {:url => url_string, :urlparts => 
                {:scheme => "https", :authority => {:userinfo => "", :password => "", :host => "tools.ietf.org", :port => ""},
                :path => {:segments => ["html","rfc3986"], :querystring => {}, :fragment => "section-3.2.1"}}
                }
            expect(URLParser.parse(url_string)).to eql(expected_url_components)
        end
    end

    describe '#parse ... ' do
        it 'parses another combination' do
            url_string = "foo://user@example.com:8080/?showme=this#here"
            expected_url_components = {:url => url_string, :urlparts => 
                {:scheme => "foo", :authority => {:userinfo => "user", :password => "", :host => "example.com", :port => "8080"},
                :path => {:segments => [], :querystring => {:showme => "this"}, :fragment => "here"}}
                }
            expect(URLParser.parse(url_string)).to eql(expected_url_components)
        end
    end

    describe '#parse ... ' do
        it 'parses another combination' do
            url_string = "foo://example.com:8080/?showme=this#here"
            expected_url_components = {:url => url_string, :urlparts => 
                {:scheme => "foo", :authority => {:userinfo => "", :password => "", :host => "example.com", :port => "8080"},
                :path => {:segments => [], :querystring => {:showme => "this"}, :fragment => "here"}}
                }
            expect(URLParser.parse(url_string)).to eql(expected_url_components)
        end
    end
   
end