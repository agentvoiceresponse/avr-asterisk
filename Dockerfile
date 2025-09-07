FROM ubuntu:22.04 AS builder

ENV AST_VERSION=22.4.0

RUN set -ex; \
    apt-get update; \
    export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true; \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        build-essential pkg-config \
        wget subversion bzip2 patch \
        libedit-dev libjansson-dev libsqlite3-dev uuid-dev libxml2-dev  \
        liburiparser1 libgsm1 libcurl4-openssl-dev libssl-dev openssl libsrtp2-dev libsrtp2-1; \
    cd /usr/src; \
    echo "check_certificate = off" >> ~/.wgetrc; \
    wget "https://github.com/asterisk/asterisk/archive/refs/tags/${AST_VERSION}.tar.gz"; \
    tar xvf ${AST_VERSION}.tar.gz; \
    cd /usr/src/asterisk-${AST_VERSION}*/; \
    ./configure --with-jansson-bundled --with-pjproject-bundled --disable-xmldoc --without-libxslt --without-dahdi ; \
    make menuselect/menuselect menuselect-tree menuselect.makeopts; \
    menuselect/menuselect --disable BUILD_NATIVE menuselect.makeopts; \
    echo ">>DISABLE deprecated modules/apps"; \
    # menuselect/menuselect --disable chan_sip menuselect.makeopts; \
    menuselect/menuselect --disable res_adsi menuselect.makeopts; \
    menuselect/menuselect --disable app_adsiprog menuselect.makeopts; \
    menuselect/menuselect --disable app_getcpeid menuselect.makeopts; \
    menuselect/menuselect --disable app_celgenuserevent menuselect.makeopts; \
    echo ">>DISABLE cdr and db/sql modules/apps"; \
    menuselect/menuselect --disable app_cdr menuselect.makeopts; \
    menuselect/menuselect --disable app_db menuselect.makeopts; \
    menuselect/menuselect --disable cdr_adaptive_odbc menuselect.makeopts; \
    menuselect/menuselect --disable cdr_pgsql menuselect.makeopts; \
    menuselect/menuselect --disable cdr_odbc menuselect.makeopts; \
    menuselect/menuselect --disable cdr_tds menuselect.makeopts; \
    menuselect/menuselect --disable cdr_sqlite3_custom menuselect.makeopts; \
    menuselect/menuselect --disable func_cdr menuselect.makeopts; \
    menuselect/menuselect --disable cdr_csv menuselect.makeopts; \
    menuselect/menuselect --disable app_forkcdr menuselect.makeopts; \
    menuselect/menuselect --disable cdr_custom menuselect.makeopts; \
    menuselect/menuselect --disable cdr_radius menuselect.makeopts; \
    menuselect/menuselect --disable cdr_manager menuselect.makeopts; \
    menuselect/menuselect --disable func_odbc menuselect.makeopts; \
    menuselect/menuselect --disable res_config_odbc menuselect.makeopts; \
    menuselect/menuselect --disable res_odbc menuselect.makeopts; \
    menuselect/menuselect --disable res_odbc_transaction menuselect.makeopts; \
    menuselect/menuselect --disable cel_odbc menuselect.makeopts; \
    menuselect/menuselect --disable cel_pgsql menuselect.makeopts; \
    menuselect/menuselect --disable cel_tds menuselect.makeopts; \
    menuselect/menuselect --disable cel_sqlite3_custom menuselect.makeopts; \
    menuselect/menuselect --disable cel_radius menuselect.makeopts; \
    menuselect/menuselect --disable res_config_sqlite3 menuselect.makeopts; \
    menuselect/menuselect --disable res_config_pgsql menuselect.makeopts; \
    menuselect/menuselect --disable func_db menuselect.makeopts; \
    menuselect/menuselect --disable pbx_realtime menuselect.makeopts; \
    echo ">>DISABLE unused codec"; \
    menuselect/menuselect --disable codec_g726 menuselect.makeopts; \
    menuselect/menuselect --disable codec_g722 menuselect.makeopts; \
    menuselect/menuselect --disable codec_adpcm menuselect.makeopts; \
    menuselect/menuselect --disable codec_a_mu menuselect.makeopts; \
    menuselect/menuselect --disable codec_ilbc menuselect.makeopts; \
    menuselect/menuselect --disable codec_lpc10 menuselect.makeopts; \
    menuselect/menuselect --disable codec_speex menuselect.makeopts; \
    menuselect/menuselect --disable format_h264 menuselect.makeopts; \
    menuselect/menuselect --disable format_h263 menuselect.makeopts; \
    menuselect/menuselect --disable format_g726 menuselect.makeopts; \
    menuselect/menuselect --disable format_g723 menuselect.makeopts; \
    menuselect/menuselect --disable codec_g729a menuselect.makeopts; \
    menuselect/menuselect --disable format_ogg_vorbis menuselect.makeopts; \
    menuselect/menuselect --disable res_format_attr_celt menuselect.makeopts; \
    menuselect/menuselect --disable res_format_attr_h263 menuselect.makeopts; \
    menuselect/menuselect --disable res_format_attr_h264 menuselect.makeopts; \
    echo ">>DISABLE unused modules/apps"; \
    menuselect/menuselect --disable chan_iax2 menuselect.makeopts; \
    menuselect/menuselect --disable chan_motif menuselect.makeopts; \
    menuselect/menuselect --disable chan_unistim menuselect.makeopts; \
    menuselect/menuselect --disable chan_console menuselect.makeopts; \
    menuselect/menuselect --disable cel_manager menuselect.makeopts; \
    menuselect/menuselect --disable cel_custom menuselect.makeopts; \
    menuselect/menuselect --disable res_geolocation menuselect.makeopts; \
    menuselect/menuselect --disable res_fax  menuselect.makeopts; \
    menuselect/menuselect --disable res_xmpp menuselect.makeopts; \
    menuselect/menuselect --disable res_stir_shaken menuselect.makeopts; \
    menuselect/menuselect --disable res_ael_share menuselect.makeopts; \
    menuselect/menuselect --disable res_parking menuselect.makeopts; \
    menuselect/menuselect --disable res_calendar_caldav menuselect.makeopts; \
    menuselect/menuselect --disable res_aeap menuselect.makeopts; \
    menuselect/menuselect --disable res_calendar menuselect.makeopts; \
    menuselect/menuselect --disable res_snmp menuselect.makeopts; \
    menuselect/menuselect --disable res_phoneprov menuselect.makeopts; \
    menuselect/menuselect --disable res_config_ldap menuselect.makeopts; \
    menuselect/menuselect --disable res_smdi menuselect.makeopts; \
    menuselect/menuselect --disable res_sorcery_memory_cache menuselect.makeopts; \
    menuselect/menuselect --disable res_calendar_ews menuselect.makeopts; \
    menuselect/menuselect --disable res_calendar_icalendar menuselect.makeopts; \
    menuselect/menuselect --disable res_http_media_cache menuselect.makeopts; \
    menuselect/menuselect --disable res_calendar_exchange menuselect.makeopts; \
    menuselect/menuselect --disable res_speech_aeap menuselect.makeopts; \
    menuselect/menuselect --disable res_resolver_unbound menuselect.makeopts; \
    menuselect/menuselect --disable res_statsd menuselect.makeopts; \
    menuselect/menuselect --disable res_stun_monitor menuselect.makeopts; \
    menuselect/menuselect --disable res_sorcery_realtime menuselect.makeopts; \
    menuselect/menuselect --disable res_hep menuselect.makeopts; \
    menuselect/menuselect --disable res_hep_rtcp menuselect.makeopts; \
    menuselect/menuselect --disable res_hep_pjsip menuselect.makeopts; \
    menuselect/menuselect --disable res_pjsip_t38 menuselect.makeopts; \
    menuselect/menuselect --disable res_pjsip_config_wizard menuselect.makeopts; \
    menuselect/menuselect --disable res_pjsip_phoneprov_provider menuselect.makeopts; \
    menuselect/menuselect --disable pbx_lua menuselect.makeopts; \
    menuselect/menuselect --disable pbx_ael menuselect.makeopts; \
    menuselect/menuselect --disable pbx_spool menuselect.makeopts; \
    menuselect/menuselect --disable pbx_loopback menuselect.makeopts; \
    menuselect/menuselect --disable pbx_dundi menuselect.makeopts; \
    menuselect/menuselect --disable func_env menuselect.makeopts; \
    menuselect/menuselect --disable func_speex menuselect.makeopts; \
    menuselect/menuselect --disable func_srv menuselect.makeopts; \
    menuselect/menuselect --disable func_groupcount menuselect.makeopts; \
    menuselect/menuselect --disable func_holdintercept menuselect.makeopts; \
    menuselect/menuselect --disable func_aes menuselect.makeopts; \
    menuselect/menuselect --disable func_devstate menuselect.makeopts; \
    menuselect/menuselect --disable func_pitchshift menuselect.makeopts; \
    menuselect/menuselect --disable func_cut menuselect.makeopts; \
    menuselect/menuselect --disable func_enum menuselect.makeopts; \
    menuselect/menuselect --disable func_dialgroup menuselect.makeopts; \
    menuselect/menuselect --disable func_sorcery menuselect.makeopts; \
    menuselect/menuselect --disable func_presencestate menuselect.makeopts; \
    menuselect/menuselect --disable func_math menuselect.makeopts; \
    menuselect/menuselect --disable func_periodic_hook menuselect.makeopts; \
    menuselect/menuselect --disable app_confbridge menuselect.makeopts; \
    menuselect/menuselect --disable app_zapateller menuselect.makeopts; \
    menuselect/menuselect --disable app_voicemail menuselect.makeopts; \
    menuselect/menuselect --disable app_minivm menuselect.makeopts; \
    menuselect/menuselect --disable app_agent_pool menuselect.makeopts; \
    menuselect/menuselect --disable app_followme menuselect.makeopts; \
    menuselect/menuselect --disable app_chanspy menuselect.makeopts; \
    menuselect/menuselect --disable app_jack menuselect.makeopts; \
    menuselect/menuselect --disable app_sms menuselect.makeopts; \
    menuselect/menuselect --disable app_directory menuselect.makeopts; \
    menuselect/menuselect --disable app_externalivr menuselect.makeopts; \
    menuselect/menuselect --disable app_speech_utils menuselect.makeopts; \
    menuselect/menuselect --disable app_alarmreceiver menuselect.makeopts; \
    menuselect/menuselect --disable app_broadcast menuselect.makeopts; \
    menuselect/menuselect --disable app_amd menuselect.makeopts; \
    menuselect/menuselect --disable app_test menuselect.makeopts; \
    menuselect/menuselect --disable app_festival menuselect.makeopts; \
    menuselect/menuselect --disable app_disa menuselect.makeopts; \
    menuselect/menuselect --disable app_mf menuselect.makeopts; \
    menuselect/menuselect --disable app_dictate menuselect.makeopts; \
    menuselect/menuselect --disable app_signal menuselect.makeopts; \
    menuselect/menuselect --disable app_sf menuselect.makeopts; \
    menuselect/menuselect --disable app_page menuselect.makeopts; \
    menuselect/menuselect --disable app_mp3 menuselect.makeopts; \
    menuselect/menuselect --disable app_directed_pickup menuselect.makeopts; \
    menuselect/menuselect --disable app_morsecode menuselect.makeopts; \
    menuselect/menuselect --disable app_sendtext menuselect.makeopts; \
    echo "ENABLE pjsip"; \
    menuselect/menuselect --enable pbx_config menuselect.makeopts; \
    menuselect/menuselect --enable chan_pjsip menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip menuselect.makeopts; \
    menuselect/menuselect --enable res_sorcery_astdb menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_acl menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_authenticator_digest menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_caller_id menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_dialog_info_body_generator menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_diversion menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_dlg_options menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_dtmf_info menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_empty_info menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_endpoint_identifier_anonymous menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_endpoint_identifier_ip menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_endpoint_identifier_user menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_exten_state menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_header_funcs menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_logger menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_sdp_rtp menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_session menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_history menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_transport_websocket menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_xpidf_body_generator menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_pidf_body_generator menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_mwi_body_generator menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_rfc3329 menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_messaging menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_pidf_digium_body_supplement menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_pidf_eyebeam_body_supplement menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_sips_contact menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_stir_shaken menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_refer menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_path menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_mwi menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_one_touch_record_info menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_send_to_voicemail menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_outbound_registration menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_nat menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_publish_asterisk menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_outbound_publish menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_pubsub menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_registrar menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_outbound_authenticator_digest menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_rfc3326 menuselect.makeopts; \
    menuselect/menuselect --enable res_pjsip_notify menuselect.makeopts; \
    menuselect/menuselect --enable func_pjsip_endpoint menuselect.makeopts; \
    menuselect/menuselect --enable func_pjsip_contact menuselect.makeopts; \
    menuselect/menuselect --enable func_pjsip_aor menuselect.makeopts; \
    menuselect/menuselect --enable chan_audiosocket menuselect.makeopts; \
    menuselect/menuselect --enable codec_gsm menuselect.makeopts; \
    menuselect/menuselect --enable format_gsm menuselect.makeopts; \
    menuselect/menuselect --enable res_agi menuselect.makeopts; \
    menuselect/menuselect --enable res_prometheus menuselect.makeopts; \
    menuselect/menuselect --enable res_srtp menuselect.makeopts; \
    make -j$(grep -c ^processor /proc/cpuinfo); \
    make install; \
    make samples; \
    make config; \
    mkdir -p /etc/asterisk/keys; \
    ./contrib/scripts/ast_tls_cert -C agentvoiceresponse.local -O "Agent Voice Response" -d /etc/asterisk/keys -e; \
    chmod 600 /etc/asterisk/keys/*.*; \
    apt-get remove -y --purge --auto-remove build-essential software-properties-common lib*dev; \
    apt-get clean && rm -rf /var/lib/{apt,dpkg,cache,log}; \
    rm -rf /usr/src/${AST_VERSION}* && rm -rf /usr/src/asterisk*;


FROM ubuntu:22.04
RUN set -ex; \
    apt-get update; \
    export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true; \
    apt-get install -y --no-install-recommends  \
       wget sox tzdata libedit2 libjansson4 libsqlite3-0 libuuid1 libxml2 uuid-runtime  \
       jq curl \
       liburiparser1 libgsm1 libcurl4 libcurl4-openssl-dev libssl-dev openssl libsrtp2-dev libsrtp2-1; \
    apt-get clean && rm -rf /var/lib/{apt,dpkg,cache,log};

COPY --from=builder /var/spool/asterisk /var/spool/asterisk
COPY --from=builder /var/lib/asterisk /var/lib/asterisk
COPY --from=builder /var/run/asterisk /var/run/asterisk
COPY --from=builder /usr/lib/asterisk /usr/lib/asterisk
COPY --from=builder /etc/asterisk /etc/asterisk

COPY --from=builder /usr/sbin/astcanary \
                    /usr/sbin/astdb2bdb \
                    /usr/sbin/astdb2sqlite3 \
                    /usr/sbin/asterisk \
                    /usr/sbin/astgenkey \
                    /usr/sbin/astversion \
                    /usr/sbin/autosupport \
                    /usr/sbin/rasterisk \
                    /usr/sbin/safe_asterisk \
                    /usr/sbin/

COPY --from=builder /usr/lib/libasteriskssl.so.1 \
                    /usr/lib/libasteriskssl.so \
                    /usr/lib/libasteriskpj.so.2 \
                    /usr/lib/libasteriskpj.so \
                    /usr/lib/

RUN sed -i 's/enabled = no/enabled = yes/' /etc/asterisk/manager.conf; \
    sed -i 's/rtpend=20000/rtpend=10050/' /etc/asterisk/rtp.conf; \
    sed -i 's/; stunaddr=/stunaddr=stun.l.google.com:19302/' /etc/asterisk/rtp.conf; \
    sed -i 's/enabled = no/enabled = yes/' /etc/asterisk/prometheus.conf; \
    sed -i 's/;enabled=yes/enabled=yes/' /etc/asterisk/http.conf; \
    sed -i 's/bindaddr=127.0.0.1/bindaddr=0.0.0.0/' /etc/asterisk/http.conf; \
    sed -i 's/;tlsenable=yes/tlsenable=yes/' /etc/asterisk/http.conf; \
    sed -i 's/;tlsbindaddr=0.0.0.0:8089/tlsbindaddr=0.0.0.0:8089/' /etc/asterisk/http.conf; \
    sed -i 's/;tlscertfile=/tlscertfile=\/etc\/asterisk\/keys\/asterisk.crt/' /etc/asterisk/http.conf; \
    sed -i 's/;tlsprivatekey=/tlsprivatekey=\/etc\/asterisk\/keys\/asterisk.key/' /etc/asterisk/http.conf; 

RUN echo "#include \"my_extensions.conf\"" >> "/etc/asterisk/extensions.conf"; \
    echo "#include \"my_pjsip.conf\"" >> "/etc/asterisk/pjsip.conf"; \
    echo "#include \"my_manager.conf\"" >> "/etc/asterisk/manager.conf"; \
    echo "#include \"my_queues.conf\"" >> "/etc/asterisk/queues.conf"; \
    echo "#include \"my_ari.conf\"" >> "/etc/asterisk/ari.conf";

ENV TZ=Europe/Rome
RUN set -ex; \
    echo $TZ > /etc/timezone; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime;

# if need curl for Global Web
# RUN set -ex; \
#     apt-get install -y --no-install-recommends ca-certificates;

CMD [ "asterisk", "-f" ]