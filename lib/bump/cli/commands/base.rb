require 'open-uri'

module Bump
  class CLI
    module Commands
      class Base < Hanami::CLI::Command
        private

        def headers(options)
          default_headers
        end

        def default_headers
          {
            "Content-Type" => "application/json"
          }
        end

        def display_error(response)
          if response.code == 422
            body = JSON.parse(response.body)
            display_invalid_definition(body)
          elsif response.code == 401
            abort "Invalid authentication string (status: 401)"
          else
            abort "Unknown error (status: #{response.code})"
          end
        end

        def display_invalid_definition(body)
          puts "Definition is not valid:"
          body["errors"]["raw_definition"].each do |error|
            puts "> #{error}"
          end
          abort
        end

        def display_http_error(error)
          abort "#{error.class}: #{error.message}"
        end
      end
    end
  end
end
