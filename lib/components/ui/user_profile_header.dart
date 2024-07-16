import 'package:flutter/material.dart';

class UserProfileHeader extends StatefulWidget {
  final String imageAsset;
  final String? imageNetwork;
  final String userName;
  final String? objectName;
  final VoidCallback? onAddPhotoPressed;

  const UserProfileHeader({
    Key? key,
    required this.imageAsset,
    this.imageNetwork,
    required this.userName,
    this.onAddPhotoPressed,
    this.objectName,
  }) : super(key: key);

  @override
  _UserProfileHeaderState createState() => _UserProfileHeaderState();
}

class _UserProfileHeaderState extends State<UserProfileHeader> {
  bool _isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    _checkImage();
  }

  @override
  void didUpdateWidget(UserProfileHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageNetwork != oldWidget.imageNetwork) {
      _isImageLoaded = false;
      _checkImage();
    }
  }

  void _checkImage() {
    if (widget.imageNetwork != null && widget.imageNetwork!.isNotEmpty) {
      Image.network(widget.imageNetwork!)
          .image
          .resolve(const ImageConfiguration())
          .addListener(
            ImageStreamListener(
              (ImageInfo info, bool synchronousCall) {
                if (mounted) {
                  setState(() {
                    _isImageLoaded = true;
                  });
                }
              },
              onError: (dynamic exception, StackTrace? stackTrace) {
                if (mounted) {
                  setState(() {
                    _isImageLoaded = false;
                  });
                }
                debugPrint('Error loading image: $exception');
              },
            ),
          );
    } else {
      setState(() {
        _isImageLoaded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
      color: const Color(0xFF18232D),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(48, 255, 255, 255),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 16),
                ),
              ),
              const Expanded(
                child: Text(
                  'Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Opacity(
                opacity: 0,
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: 103,
                  height: 103,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(103 / 2),
                    border: _isImageLoaded
                        ? null
                        : Border.all(color: Colors.white, width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(103 / 2),
                    child: widget.imageNetwork != null &&
                            widget.imageNetwork!.isNotEmpty
                        ? Image.network(
                            widget.imageNetwork!,
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 90,
                                height: 90,
                                padding: const EdgeInsets.all(20),
                                child: Image.asset(
                                  widget.imageAsset,
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 90,
                            height: 90,
                            padding: const EdgeInsets.all(20),
                            child: Image.asset(
                              widget.imageAsset,
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                ),
                if (widget.onAddPhotoPressed != null)
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromRGBO(255, 255, 255, 0.32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: widget.onAddPhotoPressed,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        child: Text(
                          _isImageLoaded ? 'Change Photo' : 'Add Photo',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 5),
                  child: Text(
                    widget.userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (widget.objectName != null)
                  Text(
                    widget.objectName!,
                    style: const TextStyle(
                      color: Color(0xFFA5A5A7),
                      fontSize: 16,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
