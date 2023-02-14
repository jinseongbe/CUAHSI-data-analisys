WaterML_Code

01_MakeSummaryFile.R
: Summaryfile을 만드는 코드로 보통 2~3일 정도 소요됨 그냥 실행시키면 알아서 만들어짐, 다만 경로를 수정하고 Summary_Result 폴더를 해당 경로에 만들어 놓아야함!


02_ReDownloadSummaryFile.R
: 01_MakeSummaryFile.R에서 다운로드 실패한항목을 추가적으로 다운받는 코드, 사실 두번해도 비슷한 결과가. 나오므로 꼭 실행할 필요는 없다


03_AddValueDataInfomation.R
: Summaryfile안에 있는 min,max,dev,등의 실제 데이터를 정보를 입력해주는 코드, 모든 데이터를 받은뒤 계산하여 넣어주는 코드이기때문에 시간이 오래걸림, 실제로 다 입력하진 못해고 해당 코드내에 누락된 URL 번호를 입력해놓았음, 필요하다면 다시 다운받으면됨. 덮어씌우는 형식이므로 여러번 실행해도 데이터가 없어질 염려는 없음


04_01_Make_VariableNameList.R
: 데이터 변수의 index를 추가하기 위한 코드의 시작부분으로 04로 시작하는 코드는 모두 chemical과 physical의 변수 indexfmf 추가하기 위한 코드이다. 04_01_Make_VariableNameList.R 코드 그중에서 Summaryfile이 가진 변수들을 모두 모아 중복제거한뒤 하나의 변수 파일을 만들고 거기에 index를 추가해서 사전처럼 사용하기 위한 코드이다. 실행한뒤 Variable_lst.csv파일을 만들고, 해당 코드 내에서 변수명을 키워드로 사용하여 중복되는 변수명에 physical과 chemical 변수를 추가하기 위한 코드. 부분부분 드래그해서 필요한 부분만 실행해야함!


04_02_Manual_makeIndex.R
: 위의 04_01코드에서 추가하지 못한 변수 인덱스를 수동으로 추가해주는 코드, 실행뒤 R 콘솔 창에서 변수명을 한개씩 보면서 c와 p를 입력하여 chemical과 phsical을 Variable_lst.csv파일에 업데이트 해준다.


04_03_AddValueDataIndex.R
: 위에서 모두 추가해서 만든 Variable_lst.csv파일을 사용하여 Summaryfile들의 index를 업데이틑 해주는 코드, 데이터 양이 적지 않아 꽤 많은 시간이 소요됨


05_01_Collect_Data.R
: 완성된 Summary_Result에 있는 파일들로부터, 원하는 변수를 다운받기위해 전처리 하는 코드로, 원하는 변수명을 입력해서 모든 데이터에서 해당변수를 모아 하나의 엑셀파일에 저장한다(03,04코드가 선행되지 않아도 사용가능함!) 


05_02_DataDownload.R
: 위에서 모은 데이터 파일을 통해 실제 데이터를 다운받는 코드, 저장될 경로를 입력해주고 저장될 폴더를 미리 만들어줘야함!



추가적인 기타 코드
: oxygen데이터 가공할때 사용했던 코드들인데, 그때 급하게 하느라 정리가 안되어있습니다.. 꼭 필요한코드는 아니라서 필요하실때 찾아보시면 될것 같습니다.

