//
//  ChatBubbleView.swift
//  test2
//
//  Created by Akshay Sankpal on 11/05/25.
//

import UIKit
import SwiftUI
import Lottie

class ChatBubbleView: UIView {

    private let userImageView = UIImageView()
    private let nameLabel = UILabel()
    private let linkTitleLabel = UILabel()
    private let linkSubtitleLabel = UILabel()
    private let linkButton = UIButton(type: .system)
    private let messageLabel = UILabel()
    private let timeLabel = UILabel()
    private let statusImageView = UIImageView()
    private var mediaImageViews: [UIImageView] = []
    private var mediaImages: [UIImage] = []

    private let lottieView: LottieAnimationView = {
        let anim = LottieAnimationView()
        anim.loopMode = .loop
        anim.translatesAutoresizingMaskIntoConstraints = false
        anim.isHidden = true    // hidden by default
        return anim
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let reactionsPill = UIView()

    private func setupLayout() {
        let container = UIStackView()
        container.axis = .horizontal
        container.alignment = .top
        container.spacing = 5
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)

        // DP
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.image = UIImage(named: "demo_avatar") // Replace
        userImageView.layer.cornerRadius = 17.5 // Half of the width/height for circle
        userImageView.clipsToBounds = true
        userImageView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            userImageView.widthAnchor.constraint(equalToConstant: 30),
            userImageView.heightAnchor.constraint(equalToConstant: 30)
        ])

        // Bubble View
        let bubbleView = UIView()
        bubbleView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        bubbleView.layer.cornerRadius = 16
        bubbleView.translatesAutoresizingMaskIntoConstraints = false

        // Stack inside bubble
        let bubbleStack = UIStackView()
        bubbleStack.axis = .vertical
        bubbleStack.spacing = 8
        bubbleStack.translatesAutoresizingMaskIntoConstraints = false
        bubbleStack.isLayoutMarginsRelativeArrangement = true
        bubbleStack.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)

        // Name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.textColor = .label
        nameLabel.text = "~ Vineet Nandan Gupta"
        
        //reply to
        // Reply Name
        let replyNameLabel = UILabel()
        replyNameLabel.font = UIFont.boldSystemFont(ofSize: 13)
        replyNameLabel.textColor = .systemBlue
        replyNameLabel.text = "Vineet"

        // Reply Message
        let replyMsgLabel = UILabel()
        replyMsgLabel.font = UIFont.systemFont(ofSize: 13)
        replyMsgLabel.textColor = .gray
        replyMsgLabel.numberOfLines = 3
        replyMsgLabel.text = "That's a great idea! That's a great idea!That's a great idea! idea! That's a great idea!That's a great idea! idea! That's a great idea!That's a great idea! idea! That's a great idea!That's a great idea! idea! That's a great idea!That's a great idea! "

        // Vertical Stack: Name + Message
        let replyVStack = UIStackView(arrangedSubviews: [replyNameLabel, replyMsgLabel])
        replyVStack.axis = .vertical
        replyVStack.spacing = 2
        replyVStack.translatesAutoresizingMaskIntoConstraints = false

        // Vertical Line
        let replyLine = UIView()
        replyLine.backgroundColor = UIColor.systemBlue
        replyLine.translatesAutoresizingMaskIntoConstraints = false
        replyLine.widthAnchor.constraint(equalToConstant: 4).isActive = true
        replyLine.layer.cornerRadius = 2

        // Horizontal Stack: Line + VStack
        let replyHStack = UIStackView(arrangedSubviews: [replyLine, replyVStack])
        replyHStack.axis = .horizontal
        replyHStack.spacing = 8
        replyHStack.alignment = .leading
        replyHStack.translatesAutoresizingMaskIntoConstraints = false

        // ✅ Now apply the height constraint AFTER everything is created
        replyLine.heightAnchor.constraint(equalTo: replyVStack.heightAnchor).isActive = true



        // Link Preview
        let linkPreview = UIView()
        linkPreview.backgroundColor = UIColor(red: 242/255, green: 245/255, blue: 247/255, alpha: 1)
        linkPreview.layer.cornerRadius = 10
        linkPreview.translatesAutoresizingMaskIntoConstraints = false

        let linkStack = UIStackView()
        linkStack.axis = .vertical
        linkStack.spacing = 2
        linkStack.isLayoutMarginsRelativeArrangement = true
        linkStack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        linkStack.translatesAutoresizingMaskIntoConstraints = false

        linkTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        linkTitleLabel.textColor = .label
        linkTitleLabel.text = "EDTLife hiring Social Media Head in Mumbai Metropolitan Region | LinkedIn"
        linkTitleLabel.numberOfLines = 2

        linkSubtitleLabel.font = UIFont.systemFont(ofSize: 12)
        linkSubtitleLabel.textColor = .secondaryLabel
        linkSubtitleLabel.text = "Posted 6:50:41 AM. We're Hiring: Social Media..."
        linkSubtitleLabel.numberOfLines = 1

        linkButton.setTitle("linkedin.com", for: .normal)
        linkButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        linkButton.contentHorizontalAlignment = .leading
        linkButton.addTarget(self, action: #selector(openLink), for: .touchUpInside)

        linkStack.addArrangedSubview(linkTitleLabel)
        linkStack.addArrangedSubview(linkSubtitleLabel)
        linkStack.addArrangedSubview(linkButton)
        linkPreview.addSubview(linkStack)

        NSLayoutConstraint.activate([
            linkStack.topAnchor.constraint(equalTo: linkPreview.topAnchor),
            linkStack.bottomAnchor.constraint(equalTo: linkPreview.bottomAnchor),
            linkStack.leadingAnchor.constraint(equalTo: linkPreview.leadingAnchor),
            linkStack.trailingAnchor.constraint(equalTo: linkPreview.trailingAnchor)
        ])
        
        // Preview Image
        let sampleImages: [UIImage] = [
            UIImage(named: "img1")!,
            UIImage(named: "img1")!,
            UIImage(named: "img1")!,
            UIImage(named: "img1")!,
            UIImage(named: "img1")! // >4 test
        ]

        let dynamicMedia = createDynamicMediaStack(images: sampleImages)

        // Message
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.textColor = .label
        messageLabel.text = """
        Hiring for a founding team member to drive Social Media & Community at Edition.

        This will be a key hire for us. Looking for someone who is obsessed with brand and community building and is inspired to build a truly global brand from India. 🚀🚀
        """

        // Timestamp
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = .secondaryLabel
        timeLabel.text = "12:32 PM"
        timeLabel.textAlignment = .right
        
        // Status
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.image = UIImage(systemName: "checkmark.message.fill") // Replace
        statusImageView.tintColor = .gray
        NSLayoutConstraint.activate([
            statusImageView.widthAnchor.constraint(equalToConstant: 15),
            statusImageView.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        let statusTimeStack = UIStackView()
        statusTimeStack.axis = .horizontal
        statusTimeStack.spacing = 5
        statusTimeStack.isLayoutMarginsRelativeArrangement = true
        statusTimeStack.translatesAutoresizingMaskIntoConstraints = false
        
        statusTimeStack.addArrangedSubview(timeLabel)
        statusTimeStack.addArrangedSubview(statusImageView)
        
        let statusContainer = UIView()
        statusContainer.addSubview(statusTimeStack)

        NSLayoutConstraint.activate([
            statusTimeStack.trailingAnchor.constraint(equalTo: statusContainer.trailingAnchor),
            statusTimeStack.topAnchor.constraint(equalTo: statusContainer.topAnchor),
            statusTimeStack.bottomAnchor.constraint(equalTo: statusContainer.bottomAnchor)
        ])


        // Assemble bubbleStack
        bubbleStack.addArrangedSubview(nameLabel)
        bubbleStack.addArrangedSubview(replyHStack)
        bubbleStack.addArrangedSubview(linkPreview)
        bubbleStack.addArrangedSubview(dynamicMedia)
        bubbleStack.addArrangedSubview(messageLabel)
        bubbleStack.addArrangedSubview(statusContainer)
        bubbleView.addSubview(bubbleStack)

        NSLayoutConstraint.activate([
            bubbleStack.topAnchor.constraint(equalTo: bubbleView.topAnchor),
            bubbleStack.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor),
            bubbleStack.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
            bubbleStack.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor)
        ])

        container.addArrangedSubview(userImageView)
        container.addArrangedSubview(bubbleView)
        
        // Create reactions pill
        // We need to add it to the container view that has both the bubble and user image as its children
        // This ensures a common ancestor for constraints
        addSubview(reactionsPill)
        setupReactionsPill(relativeTo: bubbleView)

        // Fix the layout issue by ensuring bubbleView's width is properly constrained
        // This ensures the bubble takes available width while respecting the userImageView's size
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor)
        ])
    }

    
    private func setupReactionsPill(relativeTo bubbleView: UIView) {
        // Create reactions pill
        reactionsPill.backgroundColor = UIColor.white
        reactionsPill.layer.cornerRadius = 15
        reactionsPill.layer.borderWidth = 2
        reactionsPill.layer.borderColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1).cgColor

        reactionsPill.translatesAutoresizingMaskIntoConstraints = false
        
        // Create horizontal stack for reactions icons
        let reactionsStack = UIStackView()
        reactionsStack.axis = .horizontal
        reactionsStack.alignment = .center
        reactionsStack.spacing = 2
        reactionsStack.distribution = .fillEqually
        reactionsStack.translatesAutoresizingMaskIntoConstraints = false
        reactionsStack.isLayoutMarginsRelativeArrangement = true
        reactionsStack.layoutMargins = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 0)
        
        // Add reaction emojis
        let reactions = ["👍", "❤️", "😁"]
        for reaction in reactions {
            let emojiLabel = UILabel()
            emojiLabel.text = reaction
            emojiLabel.font = UIFont.systemFont(ofSize: 14)
            reactionsStack.addArrangedSubview(emojiLabel)
        }
        
        // Add counter label
        let counterLabel = UILabel()
        counterLabel.text = "5"
        counterLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        counterLabel.textColor = .secondaryLabel
        reactionsStack.addArrangedSubview(counterLabel)
        
        reactionsPill.addSubview(reactionsStack)
        
        NSLayoutConstraint.activate([
            reactionsStack.topAnchor.constraint(equalTo: reactionsPill.topAnchor),
            reactionsStack.bottomAnchor.constraint(equalTo: reactionsPill.bottomAnchor),
            reactionsStack.leadingAnchor.constraint(equalTo: reactionsPill.leadingAnchor),
            reactionsStack.trailingAnchor.constraint(equalTo: reactionsPill.trailingAnchor),
            
            // Position pill at bottom-left of bubble with half overlapping
            // Using safe constraints between views that have the same superview
            reactionsPill.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 10),
            reactionsPill.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 20)
        ])
    }
    
    private func createDynamicMediaStack(images: [UIImage]) -> UIView {
        self.mediaImages = images
        let containerStack = UIStackView()
        containerStack.axis = .vertical
        containerStack.spacing = 6
        containerStack.translatesAutoresizingMaskIntoConstraints = false

        let count = images.count

        func imageView(with image: UIImage, isOverlay: Bool = false, overlayText: String? = nil) -> UIView {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalToConstant: 180)
            ])
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(openFullScreenMedia))
            imageView.addGestureRecognizer(tap)
            imageView.isUserInteractionEnabled = true


            if isOverlay, let overlayText = overlayText {
                let overlay = UIView()
                overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                overlay.translatesAutoresizingMaskIntoConstraints = false

                let label = UILabel()
                label.text = overlayText
                label.textColor = .white
                label.font = .boldSystemFont(ofSize: 10)
                label.textAlignment = .center
                label.translatesAutoresizingMaskIntoConstraints = false

                overlay.addSubview(label)
                imageView.addSubview(overlay)

                NSLayoutConstraint.activate([
                    overlay.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
                    overlay.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
                    overlay.topAnchor.constraint(equalTo: imageView.topAnchor),
                    overlay.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),

                    label.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: overlay.centerYAnchor)
                ])
            }

            return imageView
        }

        switch count {
        case 1:
            let img = imageView(with: images[0])
            containerStack.addArrangedSubview(img)
            
        case 2:
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.spacing = 6
            hStack.distribution = .fillEqually
            hStack.addArrangedSubview(imageView(with: images[0]))
            hStack.addArrangedSubview(imageView(with: images[1]))
            containerStack.addArrangedSubview(hStack)

        case 3:
            containerStack.addArrangedSubview(imageView(with: images[0]))
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.spacing = 6
            hStack.distribution = .fillEqually
            hStack.addArrangedSubview(imageView(with: images[1]))
            hStack.addArrangedSubview(imageView(with: images[2]))
            containerStack.addArrangedSubview(hStack)

        case 4:
            for i in 0..<2 {
                let hStack = UIStackView()
                hStack.axis = .horizontal
                hStack.spacing = 6
                hStack.distribution = .fillEqually
                hStack.addArrangedSubview(imageView(with: images[i*2]))
                hStack.addArrangedSubview(imageView(with: images[i*2 + 1]))
                containerStack.addArrangedSubview(hStack)
            }

        default:
            for i in 0..<2 {
                let hStack = UIStackView()
                hStack.axis = .horizontal
                hStack.spacing = 6
                hStack.distribution = .fillEqually

                if i == 0 {
                    hStack.addArrangedSubview(imageView(with: images[0]))
                    hStack.addArrangedSubview(imageView(with: images[1]))
                } else {
                    hStack.addArrangedSubview(imageView(with: images[2]))
                    let overlayView = imageView(with: images[3], isOverlay: true, overlayText: "+\(count - 4)")
                    hStack.addArrangedSubview(overlayView)
                }

                containerStack.addArrangedSubview(hStack)
            }
        }

        return containerStack
    }

    @objc private func openLink() {
        if let url = URL(string: "https://www.linkedin.com/jobs/view/4190389719") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func openFullScreenMedia() {
        guard !mediaImages.isEmpty else { return }

        let viewer = MediaViewerViewController(
            images: mediaImages,
            senderName: nameLabel.text ?? "Unknown",
            time: timeLabel.text ?? "",
            caption: messageLabel.text
        )

        if let topVC = UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController {
            if let sheet = viewer.sheetPresentationController {
                sheet.detents = [
                    .large()
                ]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 20
            }

            topVC.present(viewer, animated: true)
        }
    }



}

// Proper UIViewRepresentable (not UIViewControllerRepresentable) for the UIView
struct ChatBubbleViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> ChatBubbleView {
        return ChatBubbleView()
    }
    
    func updateUIView(_ uiView: ChatBubbleView, context: Context) {
        // Update the view if needed
    }
}

struct ChatBubbleViewDisplay: View {
    var body: some View {
        ChatBubbleViewRepresentable()
            .padding(.trailing, 40)
            .padding(.leading, 5)
            .background(Color(red: 245/255, green: 245/255, blue: 245/255))
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Centers content in available space
    }
}

#Preview {
    ChatBubbleViewDisplay()
}
