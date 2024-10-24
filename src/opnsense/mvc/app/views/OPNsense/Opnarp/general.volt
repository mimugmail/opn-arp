{#
 # Copyright (c) 2022 Michael Muenz <m.muenz@gmail.com>
 # All rights reserved.
 #}

<div class="content-box" style="padding-bottom: 1.5em;">
    {{ partial("layout_partials/base_form",['fields':generalForm,'id':'frm_general_settings'])}}
    <table class="table-responsive table table-striped">
        <tr>
            <td>
            Enabling this plugin will only log new MAC address pairs to system log.<br>
            If you want to get alerted by email to have to set up monit and follow /var/log/system/latest.log (after version 22.1).<br>
            Have a look at the config examples <a href="https://docs.opnsense.org/manual/monit.html">here</a>
            </td>
        </tr>
    </table>
    <div class="col-md-12">
        <hr />
        <button class="btn btn-primary" id="saveAct" type="button"><b>{{ lang._('Save') }}</b> <i id="saveAct_progress"></i></button>
        <button class="btn pull-right" id="resetdbAct" type="button"><b>{{ lang._('Reset') }}</b> <i id="resetdbAct_progress" class=""></i></button>

    </div>
</div>

<script>
    $(function() {
        var data_get_map = {'frm_general_settings':"/api/opnarp/general/get"};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        updateServiceControlUI('opnarp');

        $("#saveAct").click(function(){
            saveFormToEndpoint(url="/api/opnarp/general/set", formid='frm_general_settings',callback_ok=function(){
            $("#saveAct_progress").addClass("fa fa-spinner fa-pulse");
                ajaxCall(url="/api/opnarp/service/reconfigure", sendData={}, callback=function(data,status) {
                    updateServiceControlUI('opnarp');
                    $("#saveAct_progress").removeClass("fa fa-spinner fa-pulse");
                });
            });
        });

        $("#resetdbAct").click(function () {
            stdDialogConfirm(
                '{{ lang._('Confirm database reset') }}',
                '{{ lang._('Do you want to reset the database?') }}',
                '{{ lang._('Yes') }}', '{{ lang._('Cancel') }}', function () {
                    $("#resetdbAct_progress").addClass("fa fa-spinner fa-pulse");
                    ajaxCall(url="/api/opnarp/service/resetdb", sendData={}, callback=function(data,status) {
                        ajaxCall(url="/api/opnarp/service/reconfigure", sendData={}, callback=function(data,status) {
                        updateServiceControlUI('opnarp');
                        $("#resetdbAct_progress").removeClass("fa fa-spinner fa-pulse");
                    });
                });
            });
        });

    });
</script>
