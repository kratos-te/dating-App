
class Vinculo {
    Vinculo({
        required this.value,
        required this.label,
    });

    String value;
    String label;

    factory Vinculo.fromJson(Map<String, dynamic> json) => Vinculo(
        value: json["value"],
        label: json["label"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "label": label,
    };
}

final vinculoList=[
  Vinculo(value: 'In order to be verified on our app you must write your code clearly on a piece of paper and hold it up next to your face when taking a photo. Can you please go back into your verification settings and try to resubmit your verification image with the number that we have provided?', label: 'Verification rejection'),
  Vinculo(value: "Welcome to Unjabbed! As a new member, you're now part of a unique community of like-minded individuals. As a growing startup, we're constantly working to enhance your experience and expand our member base. If you encounter any issues or have suggestions for improvement, don't hesitate to reach out to us at info@unjabbed.app. Help us grow by spreading the word to other unvaccinated individuals about our platform. Together, we can build a vibrant, supportive community. Enjoy connecting!", label: 'Welcome Message'),
  Vinculo(value: "Policy Violation for Uploading Nudity, Obscene Images or images of minors.\nThe uploading or sharing of images that depict nudity, sexually explicit content, or images of minors on Unjabbed is in direct violation of the platform's community guidelines. This type of behavior is strictly forbidden and not tolerated. To have your account reinstated, kindly update your profile image to align with the terms of use and policies. Our team will review your updated profile image to confirm compliance with our guidelines. Upon approval, your account will be reinstated.", label: 'Your account has been suspended!'),
  Vinculo(value: "Thank you for joining the Unjabbed community! We have noticed that your profile image may not align with the gender you have selected in your profile. If this is an unintentional mistake, please feel free to visit your 'Edit info' settings and make any necessary changes. If you have any further questions or concerns, please do not hesitate to contact us at info@unjabbed.app. We are here to support you and make sure your experience on our platform is positive.", label: 'Gender Mistake Notification'),
  Vinculo(value: "Welcome to Unjabbed! A picture is worth a thousand words, and on a dating app, it could be worth a great match. We have found that profiles with a clear image of yourself have an 86% higher chance of receiving matches. Don't miss out on the opportunity to make a great first impression and increase your chances of finding love, fun, or friendship on our app. Make your profile stand out by uploading a profile image today! And, if you want to increase your chances even further, consider uploading multiple images that show different aspects of yourself and your interests.", label: 'Profile Photo '),
  Vinculo(value: "Unjabbed welcomes you! Profile pics increase match chances by 86%. Make a strong first impression & find love, fun, or friendship by uploading a clear profile pic & showcasing different aspects of yourself with multiple pics.", label: 'Profile Photo short version.'),
  Vinculo(value: "Make sure your profile stands out! Verification adds credibility and boosts your match potential.\nIt also helps us create a trustworthy community. Simply go into your app settings and click the verify section.", label: 'Verification'),
  Vinculo(value: "Thank you for joining our dating app. We take our policies very seriously and we need to ensure that all users are of legal age. Your profile image has raised some concerns and we would like to request that you provide proof of your age to ensure that you are over 18 years old, as per our policies. This can be done by sending a government-issued ID or passport that clearly displays your date of birth to accounts@unjabbed.app. Failure to provide this information will result in the termination of your account. You will have 24 hours to respond to this message. Please be assured that this information will be kept confidential and used solely for age verification purposes.Thank you for your cooperation and understanding. If you have any questions or concerns, please don't hesitate to reach out to us.", label: 'Age verification'),
  Vinculo(value: "Attention Members! We want to help you make the most of your dating experience on our site. One way to do this is by creating an engaging and informative profile. We encourage you to take a few minutes to write a brief description about yourself. This could include your hobbies, interests, and what you're looking for in a partner. A well-written profile can help attract the right people and increase your chances of finding a meaningful connection. Click on the ‘Edit info’ button to update your profile now and let others get to know the real you!", label: 'About Yourself'),
];