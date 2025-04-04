# 🕵️ Coleta de Metadados - Pentest

## 📌 Descrição

Este repositório contém um **script automatizado** para coleta de metadados em documentos encontrados na internet. A ferramenta auxilia na **identificação de informações sensíveis**, como:
- Nome de usuários;
- Versão de softwares;
- Sistema operacional utilizado;
- Entre outros dados úteis para pentesters e analistas de segurança.

## 🚀 Funcionalidades
✅ Busca por arquivos públicos no Google usando Google Dorks;
✅ Filtragem automática de URLs com documentos de interesse;
✅ Download dos arquivos localizados (.pdf, .xls, .doc, etc.);
✅ Extração de metadados utilizando `exiftool`;
✅ Limpeza automática da pasta temporária após execução.

## 📂 Estrutura do Projeto

```bash
📁 Coleta_Metadados/
│-- 📄 script.sh        # Script principal
│-- 📄 README.md       # Documentação
```

## 🛠️ Pré-requisitos

Antes de executar o script, certifique-se de que possui:

- Linux (ou WSL no Windows);
- `wget` instalado;
- `exiftool` instalado.

Instalação do `exiftool`:
```bash
sudo apt install exiftool -y
```

## 📜 Uso

Execute o script passando o domínio e o tipo de arquivo desejado:
```bash
./script.sh businesscorp.com.br pdf
```
Exemplo para buscar arquivos Excel:
```bash
./script.sh businesscorp.com.br xls
```

### 🛠 Exemplo do Código

```bash
#!/bin/bash

ALVO=$1
TYPE=$2
PASTA="desec"

if [ -z "$ALVO" ] || [ -z "$TYPE" ]; then
    echo "Uso: $0 <domínio> <tipo-de-arquivo>"
    exit 1
fi

mkdir -p "$PASTA"
lynx --dump "https://www.google.com/search?q=site:$ALVO+ext:$TYPE" | grep -Eo "https?://[^\&]+" | grep "\.$TYPE" > "$PASTA/urls.txt"

if [ ! -s "$PASTA/urls.txt" ]; then
    echo "Nenhum arquivo encontrado."
    rm -rf "$PASTA"
    exit 1
fi

echo "🔗 URLs encontradas:"
cat "$PASTA/urls.txt"

echo -e "\n📂 Extraindo metadados..."
while read url; do
    arquivo="$PASTA/$(basename "$url")"
    wget -q "$url" -O "$arquivo"
    exiftool "$arquivo"
done < "$PASTA/urls.txt"

echo -e "\n🗑️ Limpando arquivos..."
rm -rf "$PASTA"

echo "✅ Finalizado com sucesso!"
```

## ⚠️ Aviso

Este script deve ser usado **apenas para fins educacionais** e **testes autorizados**. O uso indevido pode infringir leis de privacidade e segurança.

## 📌 Autor

Criado por [@BrunoviskFe](https://github.com/BrunoviskFe) durante os estudos do módulo **Information Gathering - Business** no curso de **Pentest Profissional - DESEC**.

---
🛠 Feito com 💻 e foco em **segurança ofensiva**!

