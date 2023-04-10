import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class ArHandler extends StatefulWidget {
  const ArHandler(this.modelUrl, this.vector, {super.key});
  final String modelUrl;
  final String vector;
  @override
  // ignore: library_private_types_in_public_api
  ObjectGesturesWidgetState createState() => ObjectGesturesWidgetState();
}

class ObjectGesturesWidgetState extends State<ArHandler> {
  ARSessionManager? _arSessionManager;
  ARObjectManager? _arObjectManager;
  ARAnchorManager? _arAnchorManager;

  List<ARNode> _nodes = [];
  List<ARAnchor> _anchors = [];

  Vector3 getVector3Values(String vector3String) {
    RegExp regex = RegExp(r'[-]?\d+([.]\d+)?');
    Iterable<Match> matches = regex.allMatches(vector3String);
    List<double> values =
        matches.map((match) => double.parse(match.group(0)!)).toList();
    return Vector3(
      values[0],
      values[1],
      values[2],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _arSessionManager!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Augmenting Items'),
      // ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: _onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          // Align(
          //   alignment: FractionalOffset.bottomCenter,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       ElevatedButton(
          //         onPressed: _onRemoveEverything,
          //         child: const Text("Remove Items"),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  void _onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    _arSessionManager = arSessionManager;
    _arObjectManager = arObjectManager;
    _arAnchorManager = arAnchorManager;

    _arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "Images/triangle.png",
      showWorldOrigin: true,
      handlePans: true,
      handleRotation: true,
    );
    _arObjectManager!.onInitialize();

    _arSessionManager!.onPlaneOrPointTap = _onPlaneOrPointTapped;
    _arObjectManager!.onPanStart = _onPanStarted;
    _arObjectManager!.onPanChange = _onPanChanged;
    _arObjectManager!.onPanEnd = _onPanEnded;
    _arObjectManager!.onRotationStart = _onRotationStarted;
    _arObjectManager!.onRotationChange = _onRotationChanged;
    _arObjectManager!.onRotationEnd = _onRotationEnded;
  }

  Future<void> onRemoveEverything() async {
    /*nodes.forEach((node) {
      this.arObjectManager.removeNode(node);
    });*/
    for (var anchor in _anchors) {
      _arAnchorManager!.removeAnchor(anchor);
    }
    _anchors = [];
  }

  Future<void> _onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
        (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    if (singleHitTestResult != null) {
      var newAnchor =
          ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await _arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        _anchors.add(newAnchor);
        // Add note to anchor
        var newNode = ARNode(
          type: NodeType.webGLB,
          uri: widget.modelUrl,
          // scale: Vector3(0.5, 0.5, 0.5),
          scale: getVector3Values(widget.vector),
          position: Vector3(0.0, 0.0, 0.0),
          rotation: Vector4(1.0, 0.0, 0.0, 0.0),
        );

        // // here using this we can take the object from local
        // var newNode = ARNode(
        //     type: NodeType.localGLTF2,
        //     uri: "Models/Chicken_01/Chicken_01.gltf",
        //     scale: Vector3(0.2, 0.2, 0.2),
        //     position: Vector3(0.0, 0.0, 0.0),
        //     rotation: Vector4(1.0, 0.0, 0.0, 0.0));
        bool? didAddNodeToAnchor =
            await _arObjectManager!.addNode(newNode, planeAnchor: newAnchor);
        if (didAddNodeToAnchor!) {
          _nodes.add(newNode);
        } else {
          _arSessionManager!.onError("Adding Node to Anchor failed");
        }
      } else {
        _arSessionManager!.onError("Adding Anchor failed");
      }
    }
  }

  _onPanStarted(String nodeName) {
    debugPrint("Started panning node $nodeName");
  }

  _onPanChanged(String nodeName) {
    debugPrint("Continued panning node $nodeName");
  }

  _onPanEnded(String nodeName, Matrix4 newTransform) {
    debugPrint("Ended panning node $nodeName");
    final pannedNode = _nodes.firstWhere((element) => element.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    //pannedNode.transform = newTransform;
  }

  _onRotationStarted(String nodeName) {
    debugPrint("Started rotating node $nodeName");
  }

  _onRotationChanged(String nodeName) {
    debugPrint("Continued rotating node $nodeName");
  }

  _onRotationEnded(String nodeName, Matrix4 newTransform) {
    debugPrint("Ended rotating node $nodeName");
    final rotatedNode =
        _nodes.firstWhere((element) => element.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    //rotatedNode.transform = newTransform;
  }
}
