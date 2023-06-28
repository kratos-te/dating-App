import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
class ShowAlert {
  
  static Future image(
      BuildContext context, {
        required String image
      }) async {
       
    return showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: 450),
      transitionBuilder: (context, a1, a2, widget) {
        return ScaleTransition(
          scale: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: a1,
                  curve: const ElasticOutCurve(.8),
                  reverseCurve: Curves.easeInCubic)),
          child: FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: a1, curve: Curves.easeOutBack, reverseCurve: Curves.easeInCubic)),
            child: widget),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width*.9,
                  height: MediaQuery.of(context).size.height*.7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                    width: double.infinity,
                    child: CachedNetworkImage(
                          imageUrl:image
                      )),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              IconButton(
                onPressed: () async{
                  Navigator.pop(context);
                },
                icon:Icon(Icons.clear,color: Colors.white,),
              ),
            ],
          ),
        );
      },
    );
  }
  static Future showConfirm(
      context,{
        String title='Information',
        required String subtitle,
        String confirmTitle='Yes',
        String? image,
        String cancelTitle='No',
        bool withClose=true,
        bool withCancel=true,
        required Function yes,
      }) async {
      return showGeneralDialog(
        context: context,
        transitionDuration: const Duration(milliseconds: 450),
        transitionBuilder: (context, a1, a2, widget) {
          return ScaleTransition(
            scale: Tween(begin: 0.0, end: 1.0)
                .animate(
                    CurvedAnimation(parent: a1, curve: const ElasticOutCurve(.8),reverseCurve: Curves.easeInCubic)),
            child: FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0)
                .animate(
                    CurvedAnimation(parent: a1, curve: Curves.easeOutBack,reverseCurve: Curves.easeInCubic)),
              child: widget),
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return Center(
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Card(
                    color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: double.infinity,height: 30,),
                            Text(
                              title,
                              style:Theme.of(context).textTheme.displaySmall!.copyWith(
                                color: Colors.pink,
                                fontWeight: FontWeight.w500,
                              )
                            ),
                            const SizedBox(height: 20),
                            Text(
                              subtitle,
                              textAlign: TextAlign.center,
                              style:Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              )
                            ),
                
                            if(image!=null)...[
                               const SizedBox(height: 20),
                              Container(
                                margin: const EdgeInsets.only(bottom: 12.0),
                                child: Image.network(
                                  image,
                                  errorBuilder: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                            ],
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text(
                                    confirmTitle,
                                  ),
                                  onPressed: ([bool mounted=true]) async {
                                   await yes();
                                   if(withClose){
                
                                   if(!mounted)return;
                                   Navigator.pop(context);
                                   }
                                  },
                                ),
                              ),
                              if(withCancel)...[
                
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton(
                                  child: Text(
                                    cancelTitle,
                                  ),
                                  onPressed: ([bool mounted=true]) async {
                                   Navigator.pop(context);
                                  },
                                ),
                              ),
                              ]
                            ],
                          )
                          ],
                        ),
                      )
                    ),
                ),
                // Positioned(
                //   top: -25,
                //   left: 0,
                //   right: 0,
                //   child: CircleAvatar(
                //     radius: 30,
                //     backgroundColor: AppColors.black,
                //     child: Image.asset('assets/logo_unjabed.png',width: 50,height: 50,)
                //   ),
                // ),
              ],
            ),
          );
        }
      );
    }

}