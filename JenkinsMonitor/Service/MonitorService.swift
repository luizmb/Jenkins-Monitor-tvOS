import Alamofire

class MonitorService {
    func getMonitor(with url: String, completionHandler: @escaping (MonitorResult?, Error?) -> ()) {
        Alamofire.request(url.appending("/api/json?tree=name,jobs[name,url,color,lastBuild[displayName,estimatedDuration,timestamp,duration]]"))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let json = response.result.value as? [String: Any],
                        let monitorResult = MonitorResult.fromJson(json: json) else {
                            completionHandler(nil, NSError(domain: "Can't parse json result", code: 0, userInfo: nil))
                            return
                    }

                    completionHandler(monitorResult, nil)
                case .failure(let error):
                    completionHandler(nil, error)
                }
        }
    }
}
