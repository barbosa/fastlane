require 'fastlane_core'
require 'credentials_manager'

module PEM
  class Options
    def self.available_options
      user = CredentialsManager::AppfileConfig.try_fetch_value(:apple_dev_portal_id)
      user ||= CredentialsManager::AppfileConfig.try_fetch_value(:apple_id)

      [
        FastlaneCore::ConfigItem.new(key: :development,
                                     env_name: "PEM_DEVELOPMENT",
                                     description: "Renew the development push certificate instead of the production one",
                                     is_string: false,
                                     default_value: false),
        FastlaneCore::ConfigItem.new(key: :generate_p12,
                                     env_name: "PEM_GENERATE_P12_FILE",
                                     description: "Generate a p12 file additionally to a PEM file",
                                     is_string: false,
                                     default_value: true),
        FastlaneCore::ConfigItem.new(key: :force,
                                     env_name: "PEM_FORCE",
                                     description: "Create a new push certificate, even if the current one is active for 30 more days",
                                     is_string: false,
                                     default_value: false),
        FastlaneCore::ConfigItem.new(key: :save_private_key,
                                     short_option: "-s",
                                     env_name: "PEM_SAVE_PRIVATEKEY",
                                     description: "Set to save the private RSA key",
                                     is_string: false,
                                     default_value: true),
        FastlaneCore::ConfigItem.new(key: :app_identifier,
                                     short_option: "-a",
                                     env_name: "PEM_APP_IDENTIFIER",
                                     description: "The bundle identifier of your app",
                                     default_value: CredentialsManager::AppfileConfig.try_fetch_value(:app_identifier)),
        FastlaneCore::ConfigItem.new(key: :username,
                                     short_option: "-u",
                                     env_name: "PEM_USERNAME",
                                     description: "Your Apple ID Username",
                                     default_value: user),
        FastlaneCore::ConfigItem.new(key: :team_id,
                                     short_option: "-b",
                                     env_name: "PEM_TEAM_ID",
                                     default_value: CredentialsManager::AppfileConfig.try_fetch_value(:team_id),
                                     description: "The ID of your team if you're in multiple teams",
                                     optional: true,
                                     verify_block: proc do |value|
                                       ENV["FASTLANE_TEAM_ID"] = value
                                     end),
        FastlaneCore::ConfigItem.new(key: :team_name,
                                     short_option: "-l",
                                     env_name: "PEM_TEAM_NAME",
                                     description: "The name of your team if you're in multiple teams",
                                     optional: true,
                                     default_value: CredentialsManager::AppfileConfig.try_fetch_value(:team_name),
                                     verify_block: proc do |value|
                                       ENV["FASTLANE_TEAM_NAME"] = value
                                     end),
        FastlaneCore::ConfigItem.new(key: :p12_password,
                                     short_option: "-p",
                                     env_name: "PEM_P12_PASSWORD",
                                     description: "The password that is used for your p12 file",
                                     default_value: ""),
        FastlaneCore::ConfigItem.new(key: :pem_name,
                                     short_option: "-o",
                                     env_name: "PEM_FILE_NAME",
                                     description: "The file name of the generated .pem file",
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :output_path,
                                     short_option: "-e",
                                     env_name: "PEM_OUTPUT_PATH",
                                     description: "The path to a directory in which all certificates and private keys should be stored",
                                     default_value: ".")
      ]
    end
  end
end
