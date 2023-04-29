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
      value={code}
      highlight={(code) => highlight(code, languages[language])}
      tabSize={2}
      insertSpaces={true}
      padding={10}
      style={{
        fontFamily: "--bs-font-monospace, monospace",
        fontSize: 14,
      }}
    />
  );
}
