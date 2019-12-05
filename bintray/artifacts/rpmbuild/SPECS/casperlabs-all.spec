#
# spec file for package casperlabs-all
#
# Copyright (c) 2019 SUSE LINUX GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#


Name:           casperlabs
Version:        THIS_VERSION_MAJOR
Release:        THIS_VERSION_MINOR
Summary:        test
License:        CasperLabs Open Source License (COSL)
#Group:          
#Url:            
#Source0:        
#BuildRequires:  
Requires:       casperlabs-engine-grpc-server = THIS_VERSION, casperlabs-client = THIS_VERSION, casperlabs-node = THIS_VERSION
BuildRoot:      %{_tmppath}/%{name}-%{version}-build

%description
Meta-Package

%clean
rm -rf $RPM_BUILD_ROOT

%files

%changelog
