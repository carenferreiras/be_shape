import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class ProgressPhotosScreen extends StatefulWidget {
  const ProgressPhotosScreen({super.key});

  @override
  State<ProgressPhotosScreen> createState() => _ProgressPhotosScreenState();
}

class _ProgressPhotosScreenState extends State<ProgressPhotosScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedType = 'front';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Load initial photos
    _loadPhotos();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          switch (_tabController.index) {
            case 0:
              _selectedType = 'front';
              break;
            case 1:
              _selectedType = 'side';
              break;
            case 2:
              _selectedType = 'back';
              break;
          }
        });
        _loadPhotos();
      }
    });
  }

  void _loadPhotos() {
    context.read<ProgressPhotoBloc>().add(LoadPhotosByType(_selectedType));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
            Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios,color: BeShapeColors.backgroundLight,),),
        title: const Text('Progress Photos',style: TextStyle(color: BeShapeColors.backgroundLight),),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh,color: BeShapeColors.backgroundLight,),
            onPressed: _loadPhotos,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Front View'),
            Tab(text: 'Side View'),
            Tab(text: 'Back View'),
          ],
          indicatorColor: BeShapeColors.primary,
          labelColor: BeShapeColors.primary,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadPhotos();
        },
        color: BeShapeColors.primary,
        backgroundColor: Colors.grey[900],
        child: BlocBuilder<ProgressPhotoBloc, ProgressPhotoState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: SpinKitWaveSpinner(
                color: BeShapeColors.primary,
              ));
            }

            if (state.photos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_library,
                      size: 64,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No progress photos yet',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start tracking your progress by adding photos',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/add-progress-photo');
                      },
                      icon: const Icon(Icons.add_a_photo,color: BeShapeColors.background,),
                      label: const Text('Add First Photo',style: TextStyle(color: BeShapeColors.background),),
                      style: ElevatedButton.styleFrom(
                        iconColor: BeShapeColors.backgroundLight,
                        backgroundColor: BeShapeColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Group photos by month
            final groupedPhotos = <String, List<dynamic>>{};
            for (final photo in state.photos) {
              final monthKey = DateFormat('MMMM y').format(photo.date);
              groupedPhotos.putIfAbsent(monthKey, () => []).add(photo);
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groupedPhotos.length,
              itemBuilder: (context, index) {
                final monthKey = groupedPhotos.keys.elementAt(index);
                final monthPhotos = groupedPhotos[monthKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      monthKey,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: monthPhotos.length,
                      itemBuilder: (context, photoIndex) {
                        final photo = monthPhotos[photoIndex];
                        return _ProgressPhotoCard(photo: photo);
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-progress-photo').then((_) {
            // Reload photos when returning from add photo screen
            _loadPhotos();
          });
        },
        backgroundColor: BeShapeColors.primary,
        child: const Icon(Icons.add_a_photo, color: BeShapeColors.background,),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _ProgressPhotoCard extends StatelessWidget {
  final dynamic photo;

  const _ProgressPhotoCard({required this.photo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show photo details dialog
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      photo.photoUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('MMMM d, y').format(photo.date),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Weight: ${photo.weight}kg',
                          style: const TextStyle(
                            color: BeShapeColors.primary,
                            fontSize: 16,
                          ),
                        ),
                        if (photo.measurements != null && photo.measurements.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Measurements:',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...photo.measurements.entries.map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '${e.key.toUpperCase()}: ${e.value}cm',
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          )),
                        ],
                        if (photo.notes != null && photo.notes.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Notes:',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            photo.notes,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(photo.photoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMM d, y').format(photo.date),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${photo.weight}kg',
                    style: const TextStyle(
                      color: BeShapeColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (photo.measurements != null && photo.measurements.isNotEmpty)
                    Text(
                      'Measurements recorded',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}