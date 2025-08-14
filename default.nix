{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mojimoji";
  version = "0.0.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "studio-ousia";
    repo = "mojimoji";
    rev = "v${version}";
    hash = "sha256-NYYXiVfd94hAARew5WYlkw1kfdUQ4TkrTuHBVe4RVIA=";
  };

  build-system = [
    python3.pkgs.cython
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    cython
    mypy
    pytest
  ];

  pythonImportsCheck = [
    "mojimoji"
  ];

  meta = {
    description = "A fast converter between Japanese hankaku and zenkaku characters";
    homepage = "https://github.com/studio-ousia/mojimoji";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "mojimoji";
  };
}
