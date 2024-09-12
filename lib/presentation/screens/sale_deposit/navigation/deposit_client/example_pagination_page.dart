import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/presentation/screens/sale_deposit/navigation/deposit_client/components/custom_pagination.component.dart';

class ExamplePaginationPage extends StatelessWidget {
  const ExamplePaginationPage({Key? key}) : super(key: key);

  Future<List<String>> fetchOrdersFromApi(int page, int pageSize) async {
    await Future.delayed(const Duration(seconds: 2)); // Simuler un délai

    // Simuler une fin de données après 5 pages
    if (page > 5) {
      // Retourner une liste plus petite pour la dernière page
      return List.generate(
          pageSize ~/ 2, (index) => 'Dernière commande ${index + 1}');
    }

    // Pour les 5 premières pages, retourner une liste complète
    final res = List.generate(
        pageSize, (index) => 'Commande ${(page - 1) * pageSize + index + 1}');

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des commandes'),
      ),
      body: CustomPaginationList<String>(
        fetchItems: fetchOrdersFromApi,
        itemBuilder: (context, order) => ListTile(
          leading: const Icon(Icons.shopping_cart),
          title: Text(order),
          subtitle: Text('Détails de la commande $order'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Action lors du tap sur une commande
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Vous avez sélectionné $order')),
            );
          },
        ),
        loadingWidget: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Chargement des commandes...'),
            ],
          ),
        ),
        pageSize: 15, // Charger 15 éléments par page
      ),
    );
  }
}
