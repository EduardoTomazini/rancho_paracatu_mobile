import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'core/theme/app_colors.dart';

class AdminCardapioScreen extends StatefulWidget {
  const AdminCardapioScreen({super.key});

  @override
  State<AdminCardapioScreen> createState() => _AdminCardapioScreenState();
}

class _AdminCardapioScreenState extends State<AdminCardapioScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = false;

  // Função para buscar produtos em tempo real do banco de dados
  Future<List<Map<String, dynamic>>> _fetchProdutos() async {
    final response = await _supabase.from('produtos').select().order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // Função para abrir o formulário de Adicionar/Editar
  void _mostrarFormulario({Map<String, dynamic>? produtoAtual}) {
    final bool isEdicao = produtoAtual != null;
    final nomeController = TextEditingController(text: isEdicao ? produtoAtual['nome'] : '');
    final precoController = TextEditingController(text: isEdicao ? produtoAtual['preco'].toString() : '');
    final descController = TextEditingController(text: isEdicao ? produtoAtual['desc'] : '');
    String catSelecionada = isEdicao ? produtoAtual['cat'] : 'Porções';
    String? imagemUrl = isEdicao ? produtoAtual['imagem'] : null;
    bool isUploadingImage = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(isEdicao ? 'Editar Produto' : 'Novo Produto', style: const TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Botão de Upload de Imagem
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
                      
                      if (pickedFile != null) {
                        setStateDialog(() => isUploadingImage = true);
                        try {
                          final bytes = await pickedFile.readAsBytes();
                          final fileExt = pickedFile.name.split('.').last;
                          final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
                          
                          // Faz o upload para o Bucket "imagens"
                          await _supabase.storage.from('imagens').uploadBinary(fileName, bytes);
                          
                          // Pega o link público da imagem gerada
                          final publicUrl = _supabase.storage.from('imagens').getPublicUrl(fileName);
                          
                          setStateDialog(() {
                            imagemUrl = publicUrl;
                            isUploadingImage = false;
                          });
                        } catch (e) {
                          setStateDialog(() => isUploadingImage = false);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro no upload: $e')));
                        }
                      }
                    },
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.verdePrincipal),
                        image: imagemUrl != null ? DecorationImage(image: NetworkImage(imagemUrl!), fit: BoxFit.cover) : null,
                      ),
                      child: isUploadingImage
                          ? const Center(child: CircularProgressIndicator())
                          : imagemUrl == null
                              ? const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Icon(Icons.camera_alt, size: 40, color: Colors.grey), Text('Adicionar Foto')],
                                )
                              : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome do Produto')),
                  const SizedBox(height: 8),
                  TextField(controller: precoController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Preço (Ex: 25.50)')),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: catSelecionada,
                    items: ['Porções', 'Bebidas', 'Drinks'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) => setStateDialog(() => catSelecionada = val!),
                    decoration: const InputDecoration(labelText: 'Categoria'),
                  ),
                  const SizedBox(height: 8),
                  TextField(controller: descController, maxLines: 2, decoration: const InputDecoration(labelText: 'Descrição')),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.verdePrincipal),
                onPressed: () async {
                  if (nomeController.text.isEmpty || precoController.text.isEmpty) return;

                  final dados = {
                    'nome': nomeController.text,
                    'preco': double.tryParse(precoController.text.replaceAll(',', '.')) ?? 0.0,
                    'cat': catSelecionada,
                    'desc': descController.text,
                    'imagem': imagemUrl ?? '',
                  };

                  Navigator.pop(context);
                  setState(() => _isLoading = true);

                  try {
                    if (isEdicao) {
                      await _supabase.from('produtos').update(dados).eq('id', produtoAtual['id']);
                    } else {
                      await _supabase.from('produtos').insert(dados);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Salvo com sucesso!'), backgroundColor: Colors.green));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red));
                  }

                  setState(() => _isLoading = false);
                },
                child: const Text('Salvar', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
      },
    );
  }

  // Função para deletar produto
  void _deletarProduto(int id) async {
    setState(() => _isLoading = true);
    await _supabase.from('produtos').delete().eq('id', id);
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produto removido!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(title: const Text('Gerenciar Cardápio'), backgroundColor: AppColors.verdePrincipal),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.verdePrincipal,
        onPressed: () => _mostrarFormulario(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchProdutos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return Center(child: Text('Erro: ${snapshot.error}'));
                
                final produtos = snapshot.data ?? [];
                if (produtos.isEmpty) return const Center(child: Text('Nenhum produto cadastrado no banco de dados.'));

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: produtos.length,
                  itemBuilder: (context, index) {
                    final p = produtos[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: p['imagem'] != null && p['imagem'].toString().isNotEmpty
                            ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(p['imagem'], width: 50, height: 50, fit: BoxFit.cover))
                            : const Icon(Icons.fastfood, size: 40),
                        title: Text(p['nome'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${p['cat']} • R\$ ${p['preco']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _mostrarFormulario(produtoAtual: p)),
                            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deletarProduto(p['id'])),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}