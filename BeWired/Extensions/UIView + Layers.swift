
import UIKit

extension UIView {
    // MARK: - Shadow
    func addShadow(color: UIColor, offset: (width: Double, height: Double), radius: CGFloat, opacity: Float, alpha: CGFloat,_ isTableView: Bool)  {
        let shadowColor = color.withAlphaComponent(alpha)
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: offset.width, height: offset.height)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        if !isTableView {
            self.layer.masksToBounds = false
        }
    }
    // MARK: - Gradient
    func addGradientLayer(color: UIColor, framePoints: CGPoint, frameSize: CGSize, originalAlpha: CGFloat, layerLocations: [NSNumber], gradientStartPoint: CGPoint, gradientEndPoint: CGPoint, layerLevel: UInt32) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: framePoints.x , y: framePoints.y, width: frameSize.width, height: frameSize.height)
        
        let centerColor = color.withAlphaComponent(originalAlpha).cgColor
        let edgeColor = color.withAlphaComponent(Constants.value0).cgColor
        gradientLayer.colors = [centerColor, edgeColor]
        
        gradientLayer.locations = layerLocations
        
        gradientLayer.startPoint = gradientStartPoint
        gradientLayer.endPoint = gradientEndPoint
        
        self.layer.insertSublayer(gradientLayer, at: layerLevel)
    }
}
