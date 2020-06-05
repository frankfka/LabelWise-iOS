//
// Created by Frank Jia on 2020-05-18.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        // App configuration
        register { try? AppConfiguration() }
            .implements(Configuration.self)

        // Register device service
        register { DeviceServiceImpl() }
            .implements(DeviceService.self)

        // Register backend service
        register { LabelAnalysisServiceImpl(config: resolve(Configuration.self)) }
            .implements(LabelAnalysisService.self)
    }
}
