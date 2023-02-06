(ql:quickload "cl-ppcre")

(defun read-file (infile)
  (with-open-file (instream infile :direction :input :if-does-not-exist nil)
    (when instream 
      (let ((string (make-string (file-length instream))))
        (read-sequence string instream)
        string))))

(defun write-file (string outfile &key (action-if-exists :error))
  (check-type action-if-exists (member nil :error :new-version :rename :rename-and-delete 
					   :overwrite :append :supersede))
  (with-open-file (outstream outfile
			     :direction
			     :output
			     :if-does-not-exist :create
			     :if-exists action-if-exists)
    (write-sequence string outstream)))

(defun range (min max &optional (step 1))
  (when (<= min max)
    (cons min (range (+ min step) max step))))

(defun process_string (string &key (fname "fsi1.sif") (porosity "1.0e4 1.0e4"))
  (setf string1
	(cl-ppcre:regex-replace-all
	 "post_file_variable"
	 string
	 fname))
  (setf string2
	(cl-ppcre:regex-replace-all
	 "porosity_variable"
	 string1
	 porosity))
  string2
  )

(defun write_new_sif (infile outfile
		      &key (fname  "f10.sif")
			(porosity "0.5e04 0.5e04")
			)
  (setf readstring (process_string
		    (read-file infile)
		    :fname fname
		    :porosity porosity
		    ))
  (write-file readstring  outfile :action-if-exists :overwrite)
  )

(defun write-sif-files-to-folder (fname infile sif-folder values)
  (loop for i in values
	 do (let ((fname
		    (concatenate 'string
				 fname
				 "_t"
				 (format nil "~5,'0D" i)
				 ".vtu"
				 ))
		  (outfile
		    (concatenate 'string
				 sif-folder
				 fname
				 (format nil "~5,'0D" i)
				 ".sif"
				 ))
		  (porosity
		    (concatenate 'string
				 (let ((npor (+ 2050 (* i 40))))
				   (format nil "~5,2F ~5,2F" npor npor)
				   )))
		  )
	      (write_new_sif
	       infile
	       outfile
	       :fname fname
	       :porosity porosity )
	      ))
)
