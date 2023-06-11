import UIKit

// MARK: - Extension for hide keyboard
extension UIView {

    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }

    var topSuperview: UIView? {
        var view = superview
        while view?.superview != nil {
            view = view!.superview
        }
        return view
    }

    @objc func dismissKeyboard() {
        topSuperview?.endEditing(true)
    }
    
 
}

