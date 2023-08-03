import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["embedContainer"];

  // turbo:before-stream-render イベントが発生した際に呼び出されるメソッド
  beforeStreamRender() {
    this.updateInstagramEmbed();
  }

  // Instagramの埋め込み部分を更新するメソッド
  updateInstagramEmbed() {
    // embedContainer内のコンテンツを一旦削除
    this.embedContainerTarget.innerHTML = "";

    // Instagramの埋め込みコードを再読み込み
    // 以下のコードはInstagramの埋め込みスクリプトを動的に再読み込みするものではありませんが、
    // Instagramの埋め込みコードを改めて生成して埋め込むことで、埋め込み部分を更新できます
    const postId = this.data.get("postId");
    const embedCode = `<blockquote class="instagram-media" data-instgrm-permalink="https://www.instagram.com/p/${postId}/" data-instgrm-version="13"></blockquote><script async src="//www.instagram.com/embed.js"></script>`;
    this.embedContainerTarget.innerHTML = embedCode;
  }
}
