# SA-MP Map Editor

A Windows map editor for **San Andreas Multiplayer (SA-MP)**, based on the original [JernejL/samp-map-editor](https://github.com/JernejL/samp-map-editor).

The editor is written in Delphi/Pascal using VCL. It renders GTA: San Andreas objects through OpenGL and works directly with GTA and SA-MP map resources.

## Features

- Load GTA: San Andreas and SA-MP object definitions
- Read `.ide`, `.ipl`, `.img`, and `.col` files
- Browse models and textures from IMG archives
- Place, clone, move, rotate, and remove map objects
- Edit object coordinates, rotations, interiors, and draw distance
- Import and export IPL mappings
- Generate Pawn code using:
  - `CreateObject`
  - `CreateDynamicObject`
  - `CreateVehicle`
  - `RemoveBuildingForPlayer`
- Preview maps in the OpenGL viewport
- Export ready-to-use Pawn source files

## Downloads

Prebuilt versions are published on the [Releases page](https://github.com/mgmoldova/samp-map-editor/releases).

The release workflow can also be started manually from [GitHub Actions](https://github.com/mgmoldova/samp-map-editor/actions/workflows/release.yml).

## Building

See the detailed Russian-language [BUILD.md](BUILD.md) for tool downloads, Delphi configuration, external DLL requirements, IDE and command-line builds, troubleshooting, smoke tests, and release preparation.

## Requirements

To run the editor:

- Windows
- GTA: San Andreas
- SA-MP-compatible game files
- A 32-bit desktop color mode or higher

To build from source:

- A Delphi version compatible with the existing VCL project
- The third-party units and binaries included or referenced by the project
- A 32-bit Windows target

The codebase uses older Delphi/VCL APIs and several external components. Building it with a modern Delphi version may require compatibility changes.

## Basic usage

1. Configure the path to your GTA: San Andreas installation.
2. Load the required IMG, IDE, and IPL files.
3. Select a model from the object list.
4. Add and position objects in the 3D viewport.
5. Open the code window to generate Pawn output.
6. Export the result as a `.pwn` or `.ipl` file.

## Pawn export

Objects added in the editor can be exported in the following form:

```pawn
CreateObject(1225, 1958.33000, 1234.56000, 15.42000, 0.00000, 0.00000, 90.00000);
```

The editor also supports dynamic-object output when the corresponding option is selected.

## Object material support

Per-object `SetObjectMaterial` export is being developed in [PR #1](https://github.com/mgmoldova/samp-map-editor/pull/1).

The implementation adds:

- material replacements attached to individual object instances;
- TXD and texture selection;
- Pawn `SetObjectMaterial` and `SetDynamicObjectMaterial` generation;
- validation warnings;
- persistence in an IPL-adjacent `.materials.ini` file.

## Important source files

| File | Purpose |
| --- | --- |
| `u_Objects.pas` | Map, IDE, IPL, and object data structures |
| `u_edit.pas` | Main editor, rendering, editing, and Pawn generation |
| `u_sowcode.pas` | Generated-code window and file export |
| `u_advedit.pas` | Advanced information for the selected object |
| `u_report.pas` | Error-reporting window |
| `gtadll` | External GTA resource and rendering integration |

## Contributing

Bug reports, Delphi compatibility fixes, export improvements, and UI updates are welcome.

When submitting changes:

1. Create a feature branch.
2. Keep existing export output unchanged for unaffected objects.
3. Avoid adding new external dependencies where possible.
4. Test loading GTA resources and exporting Pawn/IPL files.
5. Open a pull request describing the affected units and validation performed.

## Credits

- Original editor: [JernejL/samp-map-editor](https://github.com/JernejL/samp-map-editor)
- Maintained fork: [mgmoldova/samp-map-editor](https://github.com/mgmoldova/samp-map-editor)

## License

No explicit license file is currently included in this repository. Verify the original project's licensing terms before redistributing binaries or substantial portions of the source code.
