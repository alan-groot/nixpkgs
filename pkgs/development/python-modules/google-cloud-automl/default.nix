{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, libcst
, google-api-core
, google-cloud-storage
, google-cloud-testutils
, pandas
, proto-plus
, pytest-asyncio
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-automl";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UjYzSWtP4cp0p7Is2qIGWBgEhjgTv0YeL0N9D7etIbY=";
  };

  propagatedBuildInputs = [ google-api-core libcst proto-plus ];

  checkInputs = [
    google-cloud-storage
    google-cloud-testutils
    mock
    pandas
    pytest-asyncio
    pytestCheckHook
  ];

  preCheck = ''
    # do not shadow imports
    rm -r google
    # requires credentials
    rm tests/system/gapic/v1beta1/test_system_tables_client_v1.py
  '';

  disabledTests = [
    # requires credentials
    "test_prediction_client_client_info"
  ];

  pythonImportsCheck = [
    "google.cloud.automl"
    "google.cloud.automl_v1"
    "google.cloud.automl_v1beta1"
  ];

  meta = with lib; {
    description = "Cloud AutoML API client library";
    homepage = "https://github.com/googleapis/python-automl";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
