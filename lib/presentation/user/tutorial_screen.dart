import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unjabbed_admin/domain/core/show_alert.dart';
import 'package:unjabbed_admin/presentation/user/tutorial_provider.dart';
import 'package:youtube/youtube_thumbnail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class TutorialWidget extends StatefulWidget {
  const TutorialWidget({super.key, required this.id});
  final String id;

  @override
  State<TutorialWidget> createState() => _TutorialWidgetState();
}

class _TutorialWidgetState extends State<TutorialWidget> {
    late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  // late VideoPlayerController _controller;
 @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      builder: (_,player){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
          ),
          body: ListView(
            children: [
              player 
            ],
          ),
        );
      },
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        // SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
          topActions: <Widget>[
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                _controller.metadata.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 25.0,
              ),
              onPressed: () {
                // log('Settings Tapped!');
              },
            ),
          ],
          onReady: () {
            _isPlayerReady = true;
          },
          // onEnded: (data) {
          //   _controller
          //       .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
          //   _showSnackBar('Next Video Started!');
          // },
        ),
    );
  }
}


class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> with AutomaticKeepAliveClientMixin {
  late Future<List<String>> getData;
  final TextEditingController ctrlVideo=TextEditingController();
  @override
  void initState() {
    final provider=Provider.of<TutorialProvider>(context, listen: false);
   getData=provider.fetchVideoIds();
    super.initState();
  }
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
     final provider=Provider.of<TutorialProvider>(context);
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppColors.pink,
      // ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder(
          future:getData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Text('Ha ocurrido un error');
            } else {
              return Row(
                children: [
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (_,__){
                        return const SizedBox(height: 20);
                      },
                      itemCount: provider.ids.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Image.network(YoutubeThumbnail(youtubeId: provider.ids[index]).hd(),height: 200,width: double.infinity,fit: BoxFit.cover,),
                            GestureDetector(
                              onTap: (){
                                // Navigator.push(context, ruta(TutorialWidget(id: provider.ids[index]), const Offset(0, 0)));
                              },
                              child: Stack(
                                children: [
                                  
                                  Container(
                                    width: double.infinity,
                                    height: 200,
                                    color: Colors.black.withOpacity(.3),
                                    child: const Center(
                                      child: Icon(
                                        Icons.play_circle,
                                        color: Colors.white,
                                        size: 60
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 20,
                                    right: 20,
                                    child: IconButton(
                                      onPressed: (){
                                        ShowAlert.showConfirm(context, subtitle: 'Are you sure you want to delete this video?', yes: ()async{
                                          if(loading)return;
                                          loading=true;
                                          await provider.deleteVideo(provider.ids[index]);
                                          loading=false;
                                        });
                                      },
                                      icon: Icon(Icons.delete,color: Colors.red,),
                                    )
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: [
                        Text('Add Video',style: TextStyle(fontSize: 20),),
                        TextFormField(
                          controller: ctrlVideo,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:loading?null: ()async{
                              loading=true;
                              await provider.addVideo(ctrlVideo.text);
                              loading=false;
                            },
                            child: Text('Add')
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
              ),
            ),
          ],
        ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}