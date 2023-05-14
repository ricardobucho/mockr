import React, { useState } from "react";
import SimpleEditor from "react-simple-code-editor";
import { highlight, languages } from "prismjs/components/prism-core";

import "prismjs/components/prism-markup";
import "prismjs/components/prism-json";
import "prismjs/components/prism-xml-doc";

export default function Editor({ code = "", language = "json" }) {
  return (
    <SimpleEditor
      readOnly
      value={code.replace(/\t/g, "  ")}
      highlight={(code) => highlight(code, languages[language])}
      style={{
        fontFamily: "--bs-font-monospace, monospace",
        fontSize: 14,
      }}
    />
  );
}
