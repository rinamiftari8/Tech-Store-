class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: (((json['rating'] as Map<String, dynamic>?)?['rate']) as num?)?.toDouble() ?? 4.5,
    );
  }

  static const fallbackProducts = [
    Product(
      id: 101,
      title: 'MacBook Pro M3 Max 16-inch',
      price: 3299.00,
      description: 'Professional laptop for developers, designers and AI workflows with premium display and high performance.',
      category: 'Laptops',
      image: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=1200&auto=format&fit=crop',
      rating: 4.9,
    ),
    Product(
      id: 102,
      title: 'Galaxy S Ultra 5G Smartphone',
      price: 1199.00,
      description: 'Flagship smartphone with bright display, advanced camera system and long battery life.',
      category: 'Smartphones',
      image: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=1200&auto=format&fit=crop',
      rating: 4.8,
    ),
    Product(
      id: 103,
      title: 'UltraWide 4K Creator Monitor',
      price: 699.99,
      description: 'Color accurate 4K monitor for coding, editing, gaming and multitasking.',
      category: 'Monitors',
      image: 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=1200&auto=format&fit=crop',
      rating: 4.7,
    ),
    Product(
      id: 104,
      title: 'Gaming Laptop RTX Studio',
      price: 1899.00,
      description: 'High refresh rate gaming laptop with RTX graphics and cooling system for long sessions.',
      category: 'Gaming',
      image: 'https://images.unsplash.com/photo-1593640408182-31c70c8268f5?w=1200&auto=format&fit=crop',
      rating: 4.8,
    ),
    Product(
      id: 105,
      title: 'Noise Cancelling Headphones Pro',
      price: 249.99,
      description: 'Premium wireless headphones with noise cancellation and studio quality audio.',
      category: 'Audio',
      image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=1200&auto=format&fit=crop',
      rating: 4.9,
    ),
    Product(
      id: 106,
      title: 'Smart Watch Health Edition',
      price: 299.99,
      description: 'Smart watch with fitness tracking, notifications, sleep insights and premium design.',
      category: 'Wearables',
      image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=1200&auto=format&fit=crop',
      rating: 4.6,
    ),
    Product(
      id: 107,
      title: 'Mechanical Keyboard RGB Pro',
      price: 139.99,
      description: 'Responsive mechanical keyboard with RGB lighting, compact layout and durable switches.',
      category: 'Accessories',
      image: 'https://images.unsplash.com/photo-1541140532154-b024d705b90a?w=1200&auto=format&fit=crop',
      rating: 4.7,
    ),
    Product(
      id: 108,
      title: 'Drone 4K Camera Explorer',
      price: 849.00,
      description: 'Compact drone with stabilized 4K camera, GPS positioning and smart flight modes.',
      category: 'Drones',
      image: 'https://images.unsplash.com/photo-1508614589041-895b88991e3e?w=1200&auto=format&fit=crop',
      rating: 4.7,
    ),
    Product(
      id: 109,
      title: 'Mirrorless Camera Content Kit',
      price: 1099.00,
      description: 'Camera kit for creators with high quality video, fast autofocus and clean image output.',
      category: 'Cameras',
      image: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=1200&auto=format&fit=crop',
      rating: 4.8,
    ),
    Product(
      id: 110,
      title: 'Smart Home Security Hub',
      price: 199.99,
      description: 'Connected smart home hub for cameras, sensors, alerts and automation routines.',
      category: 'Smart Home',
      image: 'https://images.unsplash.com/photo-1558002038-1055907df827?w=1200&auto=format&fit=crop',
      rating: 4.5,
    ),
    Product(
      id: 111,
      title: 'Tablet Pro 12.9 with Pencil',
      price: 899.00,
      description: 'Large tablet for notes, design, school, coding dashboards and entertainment.',
      category: 'Tablets',
      image: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=1200&auto=format&fit=crop',
      rating: 4.6,
    ),
    Product(
      id: 112,
      title: 'VR Headset Immersive Edition',
      price: 499.99,
      description: 'Virtual reality headset for immersive games, simulations and 3D learning experiences.',
      category: 'VR Devices',
      image: 'https://images.unsplash.com/photo-1593508512255-86ab42a8e620?w=1200&auto=format&fit=crop',
      rating: 4.5,
    ),
  ];
}
