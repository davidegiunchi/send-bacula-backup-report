<table id="id0">

<thead>
<tr>
        <th colspan="11">
                <div class="titlediv"><h1 class="newstitle">Job in the last <TMPL_VAR NAME=JOBS_SINCE_DAYS> days - click on the status to get more details</h1></div>
        </th>
</tr>
</thead>


<thead> <tr>
        <th style="background-color: rgb(225, 224, 218); cursor: pointer;">JobId</th>
        <th style="background-color: rgb(225, 224, 218); cursor: pointer;">Client</th>
        <th style="background-color: rgb(225, 224, 218); cursor: pointer;">Job Name</th>
        <th style="background-color: rgb(225, 224, 218); cursor: pointer;">FileSet</th>
        <th style="background-color: rgb(225, 224, 218); cursor: pointer;">Level</th>
        <th style="background-color: rgb(225, 224, 218); cursor: pointer;">StartTime</th>
        <th style="background-color: rgb(225, 224, 218); cursor: pointer;">Duration</th>
        <th style="background-color: rgb(225, 224, 218); cursor: pointer;">JobFiles</th>
        <th style="background-color: rgb(225, 224, 218); cursor: pointer;">JobBytes</th>
        <th style="background-color: rgb(225, 224, 218); cursor: pointer;">Errors</th>
        <th style="background-color: rgb(225, 224, 218); cursor: pointer;">Status</th>
</tr> </thead>

<tbody>

<TMPL_LOOP NAME=JOBS>

<TMPL_IF SWAP_COLOR>
<tr style="background-color: #FFFFFF;">
<TMPL_ELSE>
<tr style="background-color: #EEEEEE;">
</TMPL_IF>

<td style="padding-left: 3px; padding-right: 3px;" classname="dataTD0"><TMPL_VAR NAME=JobId></td>
<td style="padding-left: 3px; padding-right: 3px;" classname="dataTD1"><TMPL_VAR NAME=Client></td>
<td style="padding-left: 3px; padding-right: 3px;" classname="dataTD2"><TMPL_VAR NAME=JobName></td>
<td style="padding-left: 3px; padding-right: 3px;" classname="dataTD3"><TMPL_VAR NAME=FileSet></td>
<td style="padding-left: 3px; padding-right: 3px;" classname="dataTD4"><TMPL_VAR NAME=Level></td>
<td style="padding-left: 3px; padding-right: 3px;" classname="dataTD5"><TMPL_VAR NAME=StartTime></td>
<td style="padding-left: 3px; padding-right: 3px;" classname="dataTD6"><TMPL_VAR NAME=Duration></td>
<td style="padding-left: 3px; padding-right: 3px;" classname="dataTD7"><TMPL_VAR NAME=JobFiles></td>
<td style="padding-left: 3px; padding-right: 3px;" classname="dataTD8"><TMPL_VAR NAME=JobBytes></td>
<td style="padding-left: 3px; padding-right: 3px;" classname="dataTD9"><TMPL_VAR NAME=Errors></td>
<td style="padding-left: 3px; padding-right: 3px;" classname="dataTD10"><a href="<TMPL_VAR NAME=Bweb_Path>?open=Job&id=<TMPL_VAR NAME=JobId>"><TMPL_VAR NAME=Status></a></td>

</tr>
</TMPL_LOOP>

</tbody>
<tfoot><tr><th colspan="11"></th></tr></tfoot>
</table>


</body>
