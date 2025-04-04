#!/bin/bash

# Definição de variáveis
ALVO=$1   # Domínio ou palavra-chave
TYPE=$2   # Tipo de arquivo (pdf, xls, doc, etc.)
PASTA="desec"  # Pasta onde os arquivos serão baixados

# Verifica se os parâmetros foram passados
if [ -z "$ALVO" ] || [ -z "$TYPE" ]; then
    echo "Uso: $0 <domínio> <tipo-de-arquivo>"
    echo "Exemplo: $0 businesscorp.com.br pdf"
    exit 1
fi

# Cria a pasta se não existir
mkdir -p "$PASTA"

# Busca no Google usando Lynx e filtra os links corretos
lynx --dump "https://www.google.com/search?q=site:$ALVO+ext:$TYPE" | grep -Eo "https?://[^\&]+" | grep "\.$TYPE" > "$PASTA/urls.txt"

# Verifica se encontrou arquivos
if [ ! -s "$PASTA/urls.txt" ]; then
    echo "Nenhum arquivo encontrado."
    rm -rf "$PASTA"  # Remove a pasta vazia
    exit 1
fi

# Exibe a saída limpa
echo "🔗 URLs encontradas:"
cat "$PASTA/urls.txt"

# Baixa e extrai metadados dentro da pasta "desec"
echo -e "\n📂 Extraindo metadados..."
while read url; do
    arquivo="$PASTA/$(basename "$url")"  # Define caminho completo na pasta
    wget -q "$url" -O "$arquivo"
    exiftool "$arquivo"
done < "$PASTA/urls.txt"

# Limpa a pasta depois da execução
echo -e "\n🗑️ Limpando arquivos..."
rm -rf "$PASTA"

echo "✅ Finalizado com sucesso!"

