//
//  File.swift
//  
//
//  Created by Rafael Francisco on 28/09/2020.
//

import Foundation
import Vapor
import GraphQLKit

final class WeatherController {
    let weatherProcesser: WeatherProcesser
    let weatherTypeProcesser: WeatherTypesProcesser
    
    init(weatherProcesser: WeatherProcesser, typesProcesser: WeatherTypesProcesser) {
        self.weatherProcesser = weatherProcesser
        self.weatherTypeProcesser = typesProcesser
    }
    
    func fetchLocations(request: Request, _: NoArguments) throws -> [Location] {
        return weatherProcesser.locations
    }
    
    func fetchForecast(request: Request, arguments: ForecastArguments) throws -> [ForecastElement]? {
        return weatherProcesser.forecasts[weatherProcesser.locations.filter{ $0.globalIDLocal == arguments.globalId }[0]]
    }
    
    func fetchClosestLocation(request: Request, arguments: PositionArguments) throws -> Location {
        return self.getClosestLocation(arguments)
    }
    
    func fetchWeatherTypes(request: Request, _: NoArguments) throws -> [WeatherTypeData] {
        return weatherTypeProcesser.weatherTypes
    }
    
    //MARK: InternalMethods
    
    private func getClosestLocation(_ args: PositionArguments) -> Location {
        var minDistance: CGFloat = .greatestFiniteMagnitude
        var minLocation: Location?
        
        let posA = CGPoint(x: args.latitude, y: args.longitude)
        
        self.weatherProcesser.locations.forEach { location in
            let posB = CGPoint(x: Double(location.latitude)!, y: Double(location.longitude)!)
            let tempDistance = distance(posA, posB)
            
            if tempDistance < minDistance {
                minDistance = tempDistance
                minLocation = location
            }
        }
        
        return minLocation!
    }
}

extension WeatherController: FieldKeyProvider {
    typealias FieldKey = FieldKeys

    enum FieldKeys: String {
        case fetchLocations
        case fetchForecast
        case fetchClosestLocation
        case locationID
        case positionLatitude
        case positionLongitude
        case fetchWeatherTypes
    }
}
