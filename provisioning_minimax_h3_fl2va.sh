#!/bin/bash
# vast.ai PROVISIONING_SCRIPT用: MiniMax-H3 FL2VAセット自動ダウンロード
#
# 元スクリプト: download_minimax_h3.sh の「1: FL2VA → ①③④⑤をダウンロード」と同内容を
# vast.ai起動時用に非対話・冪等化したもの。
#
# vast.ai Templateでの使い方:
#   Environment Variables に以下を設定
#     PROVISIONING_SCRIPT=https://raw.githubusercontent.com/akaandoroid-spec/vastai/main/provisioning_minimax_h3_fl2va.sh
#
# ダウンロード内容 (FL2VAセット = ①③④⑤):
#   ① diffusion_models/minimax_h3_fl2va_pruned_int8_convrot.safetensors
#   ③ text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors
#   ④ vae/minimax_h3_audio_vae_fp32.safetensors
#   ⑤ vae/minimax_h3_video_vae_fp16.safetensors
#   参照元: https://huggingface.co/Comfy-Org/MiniMax-H3
#
# 任意の環境変数:
#   COMFYUI_MODELS : モデル格納ルート (default: /workspace/ComfyUI/models)
#   HF_TOKEN       : HuggingFaceトークン (レート制限・認証が必要な場合のみ。公開モデルなので通常不要)

set -euo pipefail

COMFYUI_MODELS="${COMFYUI_MODELS:-/workspace/ComfyUI/models}"
HF_TOKEN="${HF_TOKEN:-}"

URL_1="https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/diffusion_models/minimax_h3_fl2va_pruned_int8_convrot.safetensors?download=true"
DEST_1="${COMFYUI_MODELS}/diffusion_models/minimax_h3_fl2va_pruned_int8_convrot.safetensors"

URL_3="https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors?download=true"
DEST_3="${COMFYUI_MODELS}/text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors"

URL_4="https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_audio_vae_fp32.safetensors?download=true"
DEST_4="${COMFYUI_MODELS}/vae/minimax_h3_audio_vae_fp32.safetensors"

URL_5="https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_video_vae_fp16.safetensors?download=true"
DEST_5="${COMFYUI_MODELS}/vae/minimax_h3_video_vae_fp16.safetensors"

download_one() {
    local url="$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    echo "==> ダウンロード中: $dest"
    if [ -n "$HF_TOKEN" ]; then
        wget -c --tries=5 --timeout=60 \
            --header="Authorization: Bearer ${HF_TOKEN}" \
            -O "$dest" "$url"
    else
        wget -c --tries=5 --timeout=60 \
            -O "$dest" "$url"
    fi
    if [ ! -s "$dest" ]; then
        echo "エラー: ダウンロード失敗 (空ファイル): $dest" >&2
        return 1
    fi
    ls -lh "$dest"
}

echo "=================================="
echo " MiniMax-H3 FL2VA プロビジョニング開始"
echo " (download_minimax_h3.sh [1: FL2VA] 相当: ①③④⑤)"
echo " モデル格納先: $COMFYUI_MODELS"
echo "=================================="

download_one "$URL_1" "$DEST_1"
download_one "$URL_3" "$DEST_3"
download_one "$URL_4" "$DEST_4"
download_one "$URL_5" "$DEST_5"

echo "=================================="
echo " 完了しました。"
echo "=================================="
