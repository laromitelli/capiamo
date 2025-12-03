import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/message.dart';
import '../viewmodel/home_viewmodel.dart';

class MapWidget extends StatelessWidget {
  final List<Message> messages;
  final bool isLoading;
  final void Function(Message) onMarkerTap;

  const MapWidget({
    super.key,
    required this.messages,
    required this.isLoading,
    required this.onMarkerTap,
  });

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();
    final position = homeViewModel.currentPosition;

    if (position == null) {
      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      return const Center(
        child: Text('Waiting for location...'),
      );
    }

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('me'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(title: 'You are here'),
      ),
      ...messages.map(
        (m) => Marker(
          markerId: MarkerId(m.id),
          position: LatLng(m.lat, m.lon),
          infoWindow: InfoWindow(
            title: m.message,
          ),
          onTap: () => onMarkerTap(m),
        ),
      ),
    };

    final initialCameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 13,
    );

    return GoogleMap(
      initialCameraPosition: initialCameraPosition,
      markers: markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}
