import { createAvatar } from "@dicebear/core";
import * as shapes from "@dicebear/shapes";

export default {
  mounted() {
    this.el.innerHTML = avatar(this.el.getAttribute("data-seed"));
  },
};

avatar = function (seed) {
  const avatar = createAvatar(shapes, {
    seed: seed,
  });

  return avatar.toString();
};
