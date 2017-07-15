;;; bro-mode.el --- edit Bro scripts in emacs

;;; Version: 0.1
;;; Package-Version: 20170707.1647
;;; Author: Drew W. Malzahn <drew.malzahn@gmail.com>
;;; Keywords: bro, bro ids
;;; URL: https://github.com/srunnels/bro-mode

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Acknowledgments
;; ---------------

;; Original script by Scott Runnels (https://github.com/srunnels)
;; Modified by Drew Malzahn (drew.malzahn (at) gmail.com)

;;; This was done for personal edification and steals from Scott Andrew Borton's
;;; Mode Tutorial with aplomb and apologies.

;;; Many thanks to Jason Blevins and deft.el, who I copied quite a few ideas from.

(defvar bro-mode-hook nil)

(defvar bro-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-j") 'newline-and-indent)
    (define-key map (kbd "C-c C-f e") 'bro-event-lookup)
    (define-key map (kbd "C-c C-f q") 'bro-event-query)
    (define-key map (kbd "C-c C-t e") 'bro-insert-event)
    (define-key map (kbd "C-c C-b") 'bro-run)
    (define-key map (kbd "C-c C-r") 'bro-run-region)
    map)
  "Keymap for Bro major mode")

(add-to-list 'auto-mode-alist '("\\.bro\\'" . bro-mode))

;; keywords
(defconst bro-font-lock-keywords-1
  (list
   '("\\<\\(a\\(?:dd\\|larm\\)\\|break\\|c\\(?:ase\\|on\\(?:st\\|tinue\\)\\)\\|d\\(?:elete\\|o\\)\\|e\\(?:lse\\|num\\|\\(?:ven\\|xpor\\)t\\)\\|f\\(?:or\\|unction\\)\\|global\\|if\\|local\\|module\\|next\\|of\\|print\\|re\\(?:def\\|turn\\)\\|schedule\\|type\\|wh\\(?:en\\|ile\\)\\|&\\(log\\|default\\|priority\\|optional\\)\\|@load\\)\\>" . font-lock-keyword-face)
   '("\\('\\w*'\\)" . font-lock-variable-name-face))
  "Highlighting for basic keywords")

(defconst bro-font-lock-keywords-2
  (append bro-font-lock-keywords-1
          (list
           '("\\<\\(a\\(?:ddr\\|ny\\)\\|bool\\|count\\(?:er\\)?\\|double\\|file\\|int\\(?:erval\\)?\\|net\\|p\\(?:attern\\|ort\\)\\|record\\|s\\(?:et\\|tring\\|ubnet\\)\\|t\\(?:able\\|imer?\\)\\|vector\\)\\>" . font-lock-builtin-face)
           '("\\<\\(OS_version_found\\|a\\(?:c\\(?:k_above_hole\\|tivating_encryption\\)\\|nonymization_mapping\\|rp_re\\(?:ply\\|quest\\)\\|uthentication_\\(?:\\(?:accept\\|reject\\|skipp\\)ed\\)\\)\\|b\\(?:a\\(?:ckdoor_\\(?:remove_conn\\|stats\\)\\|d_\\(?:arp\\|option\\(?:_termination\\)?\\)\\)\\|ittorrent_peer_\\(?:bitfield\\|c\\(?:ancel\\|hoke\\)\\|ha\\(?:\\(?:ndshak\\|v\\)e\\)\\|interested\\|keep_alive\\|not_interested\\|p\\(?:iece\\|ort\\)\\|request\\|un\\(?:choke\\|known\\)\\|weird\\)\\|ro_\\(?:done\\|init\\|script_loaded\\)\\|t_tracker_\\(?:re\\(?:quest\\|sponse\\(?:_not_ok\\)?\\)\\|weird\\)\\)\\|con\\(?:n\\(?:_\\(?:stats\\|weird\\)\\|ection_\\(?:EOF\\|SYN_packet\\|attempt\\|e\\(?:stablished\\|xternal\\)\\|fi\\(?:nished\\|rst_ACK\\)\\|half_finished\\|p\\(?:artial_close\\|ending\\)\\|re\\(?:jected\\|set\\|used\\)\\|stat\\(?:\\(?:e_remov\\|us_updat\\)e\\)\\|timeout\\)\\)\\|tent_gap\\)\\|d\\(?:ce_rpc_\\(?:bind\\|message\\|re\\(?:quest\\|sponse\\)\\)\\|hcp_\\(?:ack\\|d\\(?:ecline\\|iscover\\)\\|inform\\|nak\\|offer\\|re\\(?:lease\\|quest\\)\\)\\|ns_\\(?:A\\(?:\\(?:6\\|AAA\\)?_reply\\)\\|CNAME_reply\\|EDNS_addl\\|HINFO_reply\\|MX_reply\\|NS_reply\\|PTR_reply\\|S\\(?:\\(?:OA\\|RV\\)_reply\\)\\|T\\(?:SIG_addl\\|XT_reply\\)\\|WKS_reply\\|end\\|full_request\\|m\\(?:apping_\\(?:altered\\|lost_name\\|new_name\\|\\(?:unverifie\\|vali\\)d\\)\\|essage\\)\\|query_reply\\|re\\(?:jected\\|quest\\)\\)\\)\\|e\\(?:pm_map_response\\|sp_packet\\|xpected_connection_seen\\)\\|f\\(?:i\\(?:le_\\(?:\\(?:open\\|transferr\\)ed\\)\\|n\\(?:ger_re\\(?:ply\\|quest\\)\\|ished_send_state\\)\\)\\|low_weird\\|tp_\\(?:re\\(?:ply\\|quest\\)\\|signature_found\\)\\)\\|g\\(?:a\\(?:obot_signature_found\\|p_report\\)\\|nutella_\\(?:binary_msg\\|establish\\|http_notify\\|not_establish\\|partial_binary_msg\\|signature_found\\|text_msg\\)\\)\\|http_\\(?:all_headers\\|begin_entity\\|content_type\\|e\\(?:n\\(?:d_entity\\|tity_data\\)\\|vent\\)\\|header\\|message_done\\|proxy_signature_found\\|re\\(?:ply\\|quest\\)\\|s\\(?:ignature_found\\|tats\\)\\)\\|i\\(?:cmp_\\(?:echo_re\\(?:ply\\|quest\\)\\|redirect\\|sent\\|time_exceeded\\|unreachable\\)\\|dent_\\(?:error\\|re\\(?:ply\\|quest\\)\\)\\|n\\(?:consistent_option\\|terconn_\\(?:remove_conn\\|stats\\)\\)\\|pv6_ext_headers\\|rc_\\(?:channel_\\(?:info\\|topic\\)\\|dcc_message\\|error_message\\|global_users\\|inv\\(?:alid_nick\\|ite_message\\)\\|join_message\\|kick_message\\|m\\(?:\\(?:ode_m\\)?essage\\)\\|n\\(?:ames_info\\|etwork_info\\|\\(?:ick\\|otice\\)_message\\)\\|oper_\\(?:\\(?:messag\\|respons\\)e\\)\\|p\\(?:\\(?:a\\(?:rt\\|ssword\\)\\|rivmsg\\)_message\\)\\|quit_message\\|re\\(?:ply\\|quest\\)\\|s\\(?:erver_info\\|ignature_found\\|qu\\(?:\\(?:ery\\|it\\)_message\\)\\)\\|\\(?:user_messag\\|who\\(?:_\\(?:lin\\|messag\\)\\|is_\\(?:channel_lin\\|messag\\|\\(?:operato\\|use\\)r_lin\\)\\)\\)e\\)\\)\\|kazaa_signature_found\\|lo\\(?:ad_sample\\|gin_\\(?:confused\\(?:_text\\)?\\|display\\|failure\\|input_line\\|output_line\\|prompt\\|success\\|terminal\\)\\)\\|m\\(?:ime_\\(?:all_\\(?:data\\|headers\\)\\|begin_entity\\|content_hash\\|e\\(?:n\\(?:d_entity\\|tity_data\\)\\|vent\\)\\|one_header\\|segment_data\\)\\|obile_ipv6_message\\)\\|n\\(?:apster_signature_found\\|cp_re\\(?:ply\\|quest\\)\\|e\\(?:t\\(?:_weird\\|bios_session_\\(?:accepted\\|keepalive\\|message\\|r\\(?:aw_message\\|e\\(?:jected\\|quest\\|t_arg_resp\\)\\)\\)\\|flow_v5_\\(?:header\\|record\\)\\)\\|w_\\(?:connection\\(?:_contents\\)?\\|packet\\)\\)\\|fs_\\(?:proc_\\(?:create\\|getattr\\|lookup\\|mkdir\\|n\\(?:ot_implemented\\|ull\\)\\|r\\(?:e\\(?:ad\\(?:dir\\|link\\)?\\|move\\)\\|mdir\\)\\|write\\)\\|reply_status\\)\\|on_dns_request\\|tp_message\\)\\|p\\(?:a\\(?:cket_contents\\|rtial_connection\\)\\|m_\\(?:attempt_\\(?:callit\\|dump\\|getport\\|null\\|\\(?:un\\)?set\\)\\|bad_port\\|request_\\(?:callit\\|dump\\|getport\\|null\\|\\(?:un\\)?set\\)\\)\\|op3_\\(?:data\\|login_\\(?:failure\\|success\\)\\|re\\(?:ply\\|quest\\)\\|terminate\\|unexpected\\)\\|r\\(?:int_hook\\|o\\(?:filing_update\\|tocol_\\(?:\\(?:confirm\\|viol\\)ation\\)\\)\\)\\)\\|r\\(?:e\\(?:mote_\\(?:c\\(?:apture_filter\\|onnection_\\(?:closed\\|e\\(?:rror\\|stablished\\)\\|handshake_done\\)\\)\\|event_registered\\|log\\(?:_peer\\)?\\|pong\\|state_\\(?:access_performed\\|inconsistency\\)\\)\\|porter_\\(?:error\\|info\\|warning\\)\\|xmit_inconsistency\\)\\|login_signature_found\\|o\\(?:ot_backdoor_signature_found\\|tate_\\(?:interval\\|size\\)\\)\\|pc_\\(?:call\\|dialogue\\|reply\\)\\|sh_re\\(?:ply\\|quest\\)\\)\\|s\\(?:ignature_match\\|m\\(?:b_\\(?:com_\\(?:close\\|generic_andx\\|logoff_andx\\|n\\(?:egotiate\\(?:_response\\)?\\|t_create_andx\\)\\|read_andx\\|setup_andx\\|tr\\(?:ans\\(?:_\\(?:mailslot\\|pipe\\|rap\\)\\|action2?\\)\\|ee_\\(?:connect_andx\\|disconnect\\)\\)\\|write_andx\\)\\|error\\|get_dfs_referral\\|message\\)\\|tp_\\(?:data\\|re\\(?:ply\\|quest\\)\\|\\(?:signature_foun\\|unexpecte\\)d\\)\\)\\|oftware_\\(?:parse_error\\|\\(?:unparsed_\\)?version_found\\)\\|s\\(?:h_\\(?:client_version\\|s\\(?:erver_version\\|ignature_found\\)\\)\\|l_\\(?:alert\\|client_hello\\|e\\(?:stablished\\|xtension\\)\\|se\\(?:rver_hello\\|ssion_ticket_handshake\\)\\)\\)\\|tp_\\(?:c\\(?:orrelate_pair\\|reate_endp\\)\\|re\\(?:move_\\(?:endp\\|pair\\)\\|sume_endp\\)\\)\\|yslog_message\\)\\|t\\(?:cp_\\(?:contents\\|option\\|\\(?:packe\\|rexmi\\)t\\)\\|elnet_signature_found\\)\\|udp_\\(?:contents\\|re\\(?:ply\\|quest\\)\\|session_done\\)\\|x509_\\(?:certificate\\|e\\(?:rror\\|xtension\\)\\)\\)\\>" . font-lock-builtin-face)

           ;; Match regex literals (but not paths)
           ;; TODO: If two separate patterns are on the same line, this will
           ;; match everything  in between. This is obviously undesirable
           ;; but it's fine as a start?...
           '("[^a-zA-Z0-9]/\\(.*\\)/" 1 font-lock-string-face)
	   ))
           "Highlighting for operators and event builtins.")

(defvar bro-font-lock-keywords bro-font-lock-keywords-2
  "Default highlighting expressions for Bro mode")

(defgroup bro
  nil
  "Variables to customize bro-mode."
  :group 'local)

(defcustom bro-tracefiles nil
  "Directory to look for tracefiles (aka network captures, pcaps, pcapngs, etc)."
  :type 'directory
  :safe 'stringp
  :group 'bro)

(defcustom bro-install-dir "/usr/share/bro/"
  "Directory to look for bro BIF."
  :type 'directory
  :safe 'stringp
  :group 'bro)

(defcustom bro-path-additional '()
  "List of additional directories to add to BROPATH. Example: ~/bin"
  :type '(repeat directory)
  :safe 'stringp
  :group 'bro)

(defvar bro-path
  (mapconcat (lambda (x) (concat (file-name-as-directory bro-install-dir) x))
	     (append '("build/src"
		       "scripts"
		       "scripts/policy"
		       "scripts/site")
		     bro-path-additional)
	     ":")
  "Default list of directories to set BROPATH."
  )

(defun bro--proper-indentation (state)
  ;; Returns the number of spaces to indent.
  (save-excursion
    (let* ((op  (point))
	   (prev-indentation (save-excursion
			       (forward-line -1)
			       (back-to-indentation)
			       (current-column)))
	   (boi (progn
		  (back-to-indentation)
		  (point)))
	   (current-indentation (current-column))
	   (bol (line-beginning-position)))
      ;; We start at the beginning of the indentation.
      (if (nth 1 state)
	  ;; We are inside a list, like {...} or (...)
	  (let (list-open-char list-open-char-indent list-top-indent)
	    (save-excursion
	      (goto-char (nth 1 state))
	      (setq list-open-char (char-after)
		    list-open-char-indent (current-column))
	      (back-to-indentation)
	      (setq list-top-indent
		    (or (save-excursion
			  (and (re-search-backward "function\\|event\\|if\\|while\\|for\\|global\\|redef")
			       (current-column)))
			(current-column))))
	    (cond
	     ;; If we're in an arglist or conditional clause, align differently
	     ((and (eq list-open-char ?\()
		   (save-excursion (goto-char (nth 1 state))
				   (back-to-indentation)
				   (looking-at "event\\|function\\|global\\|if\\|while\\|for")))
	      (+ 1 (save-excursion (goto-char (nth 1 state))
				   (current-column))))
	     ;; If we're at the end, don't indent as aggresively.
	     ((looking-at "[})]") list-top-indent)
	     (t (+ tab-width list-top-indent))))

	;; We are outside any sort of list.
	(if (save-excursion (forward-line -1)
			    (end-of-line)
			    (not (eq (char-before ?\;))))
	    ;; For indenting code like this:
	    ;; print fmt(
	    ;;     super,
	    ;;     duper,
	    ;;     long,
	    ;;     arg,
	    ;;     list
	    ;;);
	    (+ current-indentation tab-width)
	  current-indentation)
	  ))))

(defun bro-indent-line ()
  (let ((pi (bro--proper-indentation (syntax-ppss))))
    (when (and pi
               (not (eq (current-indentation) pi)))
      (indent-line-to pi))))

(defun bro-event-lookup ()
  "Retrieves the documentation for the event at point.

Requires that the bro-event-bif be set with a valid path and filename."
  (interactive)
  (let ( (bro-event-name (thing-at-point 'symbol))
	 (bro-event-bif (concat (file-name-as-directory bro-install-dir) "/scripts/base/bif/events.bif.bro") )
         (start-pos)
         (end-pos)
         (bro-event-doc)
         (bro-event-buffer))
    ;; (message "Looking for %s in %s" bro-event-name bro-event-bif)
    (if (file-exists-p bro-event-bif)
        (progn
          ;; (message "Found valid event.bif file.")
          (setq bro-event-buffer (find-file-noselect bro-event-bif))
          (save-excursion
            ;; switch to a buffer with the event.bif.bro file
            (set-buffer bro-event-buffer)
            (beginning-of-buffer)
            ;; search for the string
            (if (search-forward (format
                                 "global %s: event"
                                 bro-event-name (beginning-of-buffer))
                                nil 1)
                (progn
                  (end-of-line)
                  (setq end-pos (point))
                  (re-search-backward "^[^#]" nil t 2)
                  (setq start-pos (+ 1 (point)))
                  (setq bro-event-doc (buffer-substring start-pos end-pos))
                  (with-output-to-temp-buffer "bro-event"
                    (princ (format "%s" bro-event-doc)))
                  (save-window-excursion
                    (save-excursion
                      (switch-to-buffer "bro-event")
                      (setq buffer-read-only nil)
                      (bro-mode)))
                  (kill-buffer bro-event-buffer))
              (message "Unable to find the event specified"))))
      (message "Did not find valid event.bif file"))))

(defun bro-event-query (query)
  "Query for related events

Opens a new buffer with all global events that match the query."
  (interactive "sEvent Query: ")
  (let ((start-pos)
        (end-pos)
        (bro-query-buffer "bro-queries")
        (bro-query-results '())
	(bro-event-bif (concat (file-name-as-directory bro-install-dir) "/scripts/base/bif/events.bif.bro")))
    (message "Looking for \"%s\" in %s" query bro-event-bif)
    (if (file-exists-p bro-event-bif)
        (progn
          (message "Found valid event.bif file.")
          (setq bro-event-buffer (find-file-noselect bro-event-bif))
          (save-excursion
            (set-buffer bro-event-buffer)
            (beginning-of-buffer)
            (while (re-search-forward (format "global .*%s.*: event" query) nil t)
              (progn
                (beginning-of-line)
                (setq start-pos (point))
                (end-of-line)
                (setq end-pos (point))
                (add-to-list 'bro-query-results (buffer-substring start-pos end-pos))
                (with-output-to-temp-buffer "bro-event-list"
                  (mapc
                   (lambda (x)
                     (princ (format "%s\n" x)))
                   bro-query-results))))
            (save-window-excursion
              (save-excursion
                (switch-to-buffer "bro-event-list")
                (setq buffer-read-only nil)
                (bro-mode)
                (toggle-truncate-lines))))
          (kill-buffer bro-event-buffer))
      (message "No valid event.bif found."))))

(defun bro-insert-event()
  "Insert the built-in function at point into the kill ring."
  (interactive)
  (let ((bro-event-builtin (buffer-substring
                            (line-beginning-position)
                            (line-end-position))))
    (beginning-of-line)
    (if (looking-at "^global.*event(.*).*;")
        (progn
          (kill-new (replace-regexp-in-string
                     "global \\(.*\\): event\\(.*)\\).*;"
                     "event \\1\\2\n\t{\n\t}"
                     bro-event-builtin))
          (message "Event sent to kill-ring"))
      (message "Not a bro built in event handler;"))))

(defun bro-run(tracefile sigfile)
  "Will run the entire buffer through bro.

Will ask for a tracefile(based on bro-tracefiles) and a signature file."
  (interactive "sTracefile: \nsSignature file: ")
  (shell-command (format "bro %s %s %s"
                         (if (equal tracefile "")
                             (concat " ")
                           (concat " -r " bro-tracefiles "/" tracefile))
                         (if (equal sigfile "")
                             (concat " ")
                           (concat " -s " sigfile))
                         (concat " -e '" (buffer-substring
                                          (point-min)
                                          (point-max)) "'")
                         )))

(defun bro-run-region(tracefile sigfile)
  "Will run the region through bro

Will ask for a tracefile(based on bro-tracefiles) and a signature file"
  (interactive "sTracefile: \nsSignature file: ")
  (shell-command (format "bro %s %s %s"
                         (if (equal tracefile "")
                             (concat " ")
                           (concat " -r " bro-tracefiles "/" tracefile))
                         (if (equal sigfile "")
                             (concat " ")
                           (concat " -s " sigfile))
                         (concat " -e '" (buffer-substring
                                          (region-beginning)
                                          (region-end)) "'"))))

;;;###autoload

(define-derived-mode bro-mode prog-mode "Bro Script"
  "bro-mode is a major mode for editing Bro scripts, run by the Bro IDS."

  ;; Font lock
  (setq font-lock-defaults '(bro-font-lock-keywords))

  ;; Syntax table
  (modify-syntax-entry ?_ "w" bro-mode-syntax-table) ; Redefine a word
  (modify-syntax-entry ?$ "w" bro-mode-syntax-table)
  (modify-syntax-entry ?& "w" bro-mode-syntax-table)
  (modify-syntax-entry ?@ "w" bro-mode-syntax-table)
  (modify-syntax-entry ?# "<" bro-mode-syntax-table) ; comment-start
  (modify-syntax-entry ?\n ">" bro-mode-syntax-table) ; comment-end

  ;; Indentation
  (setq-local indent-line-function 'bro-indent-line)
  (setq-local c-basic-offset 8
	      tab-width 8
	      indent-tabs-mode t)

  ;; Set BROPATH if not set
  (if (not (getenv "BROPATH"))
      (setenv "BROPATH" bro-path)
    (setq-default bro-path (getenv "BROPATH")))

  ;; Keymap
  (use-local-map bro-mode-map)
  )

(provide 'bro-mode)
