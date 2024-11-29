import 'package:flutter/material.dart';

import '../colors/colors.dart';

class AppTextStyles {
  // Título principal
  static const TextStyle title = TextStyle(
    fontSize: 24, // Tamanho grande para títulos
    fontWeight: FontWeight.bold, // Texto em negrito
    color: AppColors.textPrimary, // Cor branca
  );

  // Texto para subtítulos ou explicações
  static const TextStyle item = TextStyle(
    fontSize: 16, // Tamanho menor
    fontWeight: FontWeight.normal, // Peso normal
    color: AppColors.textPrimary, // Cinza claro
  );

  // Texto riscado para itens concluídos
  static const TextStyle completedItem = TextStyle(
    fontSize: 16, // Tamanho médio
    fontWeight: FontWeight.normal, // Peso normal
    color: AppColors.textSecondary, // Cinza claro
    decoration: TextDecoration.lineThrough, // Linha atravessando o texto
  );
}
