% without this excel comumns are too small and you have to manualy adjust
% them so you can see tha values. This autoadjusts them.
function modify_excel_columns(file_name)
    hExcel = actxserver('Excel.Application');

    hWorkbook = hExcel.Workbooks.Open(file_name);

    % Select the entire spreadsheet.
    hExcel.Cells.Select;
    % Auto fit all the columns.
    hExcel.Cells.EntireColumn.AutoFit;
    % Center align the cell contents.
    hExcel.Selection.HorizontalAlignment = 3;
    hExcel.Selection.VerticalAlignment = 2;
    % Put "cursor" or active cell at A1, the upper left cell.
    hExcel.Range('A1').Select;

    hWorkbook.Save
    hWorkbook.Close
    hExcel.Quit
end