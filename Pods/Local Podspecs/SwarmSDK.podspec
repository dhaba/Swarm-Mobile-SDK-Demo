Pod::Spec.new do |s|
    s.name              = 'SwarmSDK'
    s.version           = '1.5'
    s.summary           = 'Swarm Beacon SDK by Swarm'
    s.homepage          = 'https://github.com/Swarm-Mobile'
    s.license           = {
        :type => 'MIT',
        :file => 'LICENSE'
    }
    s.author            = {
        'hexatlanta' => 'adam@hexatlanta.com'
    }
    s.source            = {
        :git => 'https://github.com/Swarm-Mobile/Swarm-iOs-Demo-SDK.git'
    }
    s.platform          = :ios, '7.0'
    s.exclude_files = 'SwarmSDK/{SwarmSDKTests, SwarmSDK}/*.{h,m}'
    #s.source_files = 'SwarmSDK/{Entities, Helpers, Reachability, SDK, StoreCategorization, Swarm}/**/*.{h,m}'
    s.source_files = 'SwarmSDK/**/*.{h,m}'
    s.requires_arc      = true

end
