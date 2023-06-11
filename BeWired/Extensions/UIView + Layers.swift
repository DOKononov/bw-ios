
import UIKit

extension UIView {
    // MARK: - Shadow
    func shadowPath(shadowColor: UIColor, shadowOffset: (width: Double, height: Double), shadowRadius: CGFloat, shadowOpacity: Float, alpha: CGFloat)  {
        let shadowColor = shadowColor.withAlphaComponent(alpha)
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: shadowOffset.width, height: shadowOffset.height)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
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
