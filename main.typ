#import "fhj-iee-template.typ": *
#import "helpers/lib.typ": *

// ==========================================================
// USER CONFIGURATION
// ==========================================================

#show: doc => fhj-iee-template(
  // Metadata
  title: "9-bit Circular PISO Shift Register with Parity Output",
  subtitle: "Digital Circuit Design",
  authors: (
    "Lucas Fink",
  ),
  program: PROGRAM_EEM,
  semester: "WS2026",
  language: "en",
  doc-type: "report",
  show-list-of: (),

  doc,
)

#import "@preview/lilaq:0.6.0" as lq
#import "@preview/zap:0.6.0"

#include "chapters/report.typ"


