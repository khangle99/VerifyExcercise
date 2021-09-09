import Foundation
import Network


class NetworkReach {
    
    let monitor = NWPathMonitor()
    
    func observeReachability(handle: @escaping (Bool) -> Void) {
        monitor.pathUpdateHandler = { nwPath -> Void in
            if nwPath.status == .satisfied {
                handle(true)
            } else {
                handle(false)
            }
        }
        monitor.start(queue: DispatchQueue.main)
    }
    
    func removeObserve() {
        monitor.cancel()
    }
    
}
