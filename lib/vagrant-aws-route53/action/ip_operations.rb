require 'aws-sdk-v1'

module VagrantPlugins
  module AwsRoute53
    module Action
      class IpOperations
        private
        def config(environment)
          config          = environment[:machine].config
          provider_config = environment[:machine].provider_config

          access_key_id     = provider_config.access_key_id
          secret_access_key = provider_config.secret_access_key
          region            = provider_config.region
          instance_id       = environment[:machine].id
          hosted_zone_id    = config.route53.hosted_zone_id
          record_set        = config.route53.record_set

          return access_key_id, hosted_zone_id, instance_id, record_set, region, secret_access_key
        end

        def set(options)
          ::AWS.config(access_key_id: options[:access_key_id], secret_access_key: options[:secret_access_key], region: options[:region])
          ec2 = ::AWS.ec2
          batch = ::AWS::Route53::ChangeBatch.new(options[:hosted_zone_id])
          ip = options[:public_ip] || ec2.instances[options[:instance_id]].public_ip_address
          record_sets = ::AWS::Route53::HostedZone.new(options[:hosted_zone_id]).rrsets
          record_set  = record_sets[*options[:record_set]]

          # If the ip is 0.0.0.0 then we're actually deleting this record
          if ip == '0.0.0.0'
            # If the record doesn't exist, there is no point in deleting it
            if record_set.exists? == true
              batch << ::AWS::Route53::DeleteRequest.new( options[:record_set][0], options[:record_set][1], :resource_records => [record_set.resource_records[0]], :ttl => record_set.ttl )
            end
          else
            batch << ::AWS::Route53::CreateRequest.new( options[:record_set][0], options[:record_set][1], :resource_records => [{:value => ip }], :ttl => 3600 )
          end

          if batch.length > 0
            batch.call
          end
          
          if block_given?
            yield options[:instance_id], ip, options[:record_set]
          end

          nil
        end
      end
    end
  end
end
