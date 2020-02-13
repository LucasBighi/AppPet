import UIKit

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 18
        self.clipsToBounds = true
        self.layer.bounds.size.height = 40
        self.layer.masksToBounds = true
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.lightGray, for: .disabled)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.setTitle(self.titleLabel?.text?.capitalized, for: .normal)
        
        if let image = self.image(for: .normal) {
            let tintedImage = image.withRenderingMode(.alwaysTemplate)
            self.setImage(tintedImage, for: .normal)
        }
        if let bgImage = self.backgroundImage(for: .normal) {
            let tintedImage = bgImage.withRenderingMode(.alwaysTemplate)
            self.setBackgroundImage(tintedImage, for: .normal)
        }
    }
}

