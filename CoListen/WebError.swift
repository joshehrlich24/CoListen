

import Foundation

public enum WebError: Error {
    case noInternetConnection
    case custom(String)
    case unauthorized
    case other
}

extension WebError : LocalizedError
{
    public var errorDescription: String?
    {
        switch self
        {
        case .noInternetConnection:
            return "No Internet connection"
        case .other:
            return "Something went wrong"
        case .unauthorized:
            return "Unauthorized access"
        case .custom(let message):
            return message
        }
    }
}
    extension WebError
    {
        init(json: JSON)
        {
            if let message =  json["message"] as? String
            {
                self = .custom(message)
            }
            else
            {
                self = .other
            }
        }
    }

