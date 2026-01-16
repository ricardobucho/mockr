import React, { useState } from "react";
import SimpleEditor from "react-simple-code-editor";
import { highlight, languages } from "prismjs/components/prism-core";

import "prismjs/components/prism-markup";
import "prismjs/components/prism-json";
import "prismjs/components/prism-xml-doc";

// Map common language names to prismjs language keys
const languageMap = {
  html: "markup",
  xml: "markup",
  erb: "markup",
};

export default function Editor({ code = "", language = "json" }) {
  const prismLanguage = languageMap[language] || language;
  
  return (
    <SimpleEditor
      readOnly
      value={code.replace(/\t/g, "  ")}
      highlight={(code) => highlight(code, languages[prismLanguage] || languages.markup)}
      style={{
        fontFamily: "--bs-font-monospace, monospace",
        fontSize: 14,
      }}
    />
  );
}
