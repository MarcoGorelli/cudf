# Copyright (c) 2020-2021, NVIDIA CORPORATION.

from libcpp cimport bool
from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.map cimport map
from libcpp.memory cimport shared_ptr, unique_ptr
from libc.stdint cimport uint8_t

from cudf._lib.cpp.types cimport data_type, size_type
cimport cudf._lib.cpp.io.types as cudf_io_types
cimport cudf._lib.cpp.table.table_view as cudf_table_view

cdef extern from "cudf/io/parquet.hpp" namespace "cudf::io" nogil:
    cdef cppclass parquet_reader_options:
        parquet_reader_options() except +
        cudf_io_types.source_info get_source_info() except +
        vector[string] get_columns() except +
        vector[vector[size_type]] get_row_groups() except +
        data_type get_timestamp_type() except +
        bool is_enabled_convert_strings_to_categories() except +
        bool is_enabled_use_pandas_metadata() except +
        size_type get_skip_rows() except +
        size_type get_num_rows() except +

        # setter

        void set_columns(vector[string] col_names) except +
        void set_row_groups(vector[vector[size_type]] row_grp) except +
        void enable_convert_strings_to_categories(bool val) except +
        void enable_use_pandas_metadata(bool val) except +
        void set_skip_rows(size_type val) except +
        void set_num_rows(size_type val) except +
        void set_timestamp_type(data_type type) except +

        @staticmethod
        parquet_reader_options_builder builder(
            cudf_io_types.source_info src
        ) except +

    cdef cppclass parquet_reader_options_builder:
        parquet_reader_options_builder() except +
        parquet_reader_options_builder(
            cudf_io_types.source_info src
        ) except +
        parquet_reader_options_builder& columns(
            vector[string] col_names
        ) except +
        parquet_reader_options_builder& row_groups(
            vector[vector[size_type]] row_grp
        ) except +
        parquet_reader_options_builder& convert_strings_to_categories(
            bool val
        ) except +
        parquet_reader_options_builder& use_pandas_metadata(
            bool val
        ) except +
        parquet_reader_options_builder& skip_rows(size_type val) except +
        parquet_reader_options_builder& num_rows(size_type val) except +
        parquet_reader_options_builder& timestamp_type(
            data_type type
        ) except +
        parquet_reader_options build() except +

    cdef cudf_io_types.table_with_metadata read_parquet(
        parquet_reader_options args) except +

    cdef cppclass column_in_metadata:
        column_in_metadata& set_name(const string& name)
        column_in_metadata& set_nullability(bool nullable)
        column_in_metadata& set_list_column_as_map()
        column_in_metadata& set_int96_timestamps(bool req)
        column_in_metadata& set_decimal_precision(uint8_t precision)
        column_in_metadata& child(size_type i)

    cdef cppclass table_input_metadata:
        table_input_metadata() except +
        table_input_metadata(const cudf_table_view.table_view& table) except +
        table_input_metadata(
            const cudf_table_view.table_view& table,
            map[string, string] user_data
        ) except +

        vector[column_in_metadata] column_metadata
        map[string, string] user_data

    cdef cppclass parquet_writer_options:
        parquet_writer_options() except +
        cudf_io_types.sink_info get_sink_info() except +
        cudf_io_types.compression_type get_compression() except +
        cudf_io_types.statistics_freq get_stats_level() except +
        cudf_table_view.table_view get_table() except +
        const table_input_metadata get_metadata() except +
        string get_column_chunks_file_path() except+

        void set_metadata(
            table_input_metadata *m
        ) except +
        void set_stats_level(
            cudf_io_types.statistics_freq sf
        ) except +
        void set_compression(
            cudf_io_types.compression_type compression
        ) except +
        void set_column_chunks_file_path(
            string column_chunks_file_path
        ) except +

        @staticmethod
        parquet_writer_options_builder builder(
            cudf_io_types.sink_info sink_,
            cudf_table_view.table_view table_
        ) except +

    cdef cppclass parquet_writer_options_builder:

        parquet_writer_options_builder() except +
        parquet_writer_options_builder(
            cudf_io_types.sink_info sink_,
            cudf_table_view.table_view table_
        ) except +
        parquet_writer_options_builder& metadata(
            table_input_metadata *m
        ) except +
        parquet_writer_options_builder& stats_level(
            cudf_io_types.statistics_freq sf
        ) except +
        parquet_writer_options_builder& compression(
            cudf_io_types.compression_type compression
        ) except +
        parquet_writer_options_builder& column_chunks_file_path(
            string column_chunks_file_path
        ) except +
        parquet_writer_options_builder& int96_timestamps(
            bool enabled
        ) except +

        parquet_writer_options build() except +

    cdef unique_ptr[vector[uint8_t]] write_parquet(
        parquet_writer_options args
    ) except +

    cdef cppclass chunked_parquet_writer_options:
        chunked_parquet_writer_options() except +
        cudf_io_types.sink_info get_sink() except +
        cudf_io_types.compression_type get_compression() except +
        cudf_io_types.statistics_freq get_stats_level() except +
        table_input_metadata* get_metadata(
        ) except+

        void set_metadata(
            table_input_metadata *m
        ) except +
        void set_stats_level(
            cudf_io_types.statistics_freq sf
        ) except +
        void set_compression(
            cudf_io_types.compression_type compression
        ) except +

        @staticmethod
        chunked_parquet_writer_options_builder builder(
            cudf_io_types.sink_info sink_,
        ) except +

    cdef cppclass chunked_parquet_writer_options_builder:
        chunked_parquet_writer_options_builder() except +
        chunked_parquet_writer_options_builder(
            cudf_io_types.sink_info sink_,
        ) except +
        chunked_parquet_writer_options_builder& metadata(
            table_input_metadata *m
        ) except +
        chunked_parquet_writer_options_builder& stats_level(
            cudf_io_types.statistics_freq sf
        ) except +
        chunked_parquet_writer_options_builder& compression(
            cudf_io_types.compression_type compression
        ) except +

        chunked_parquet_writer_options build() except +

    cdef cppclass parquet_chunked_writer:
        parquet_chunked_writer() except+
        parquet_chunked_writer(chunked_parquet_writer_options args) except+
        parquet_chunked_writer& write(
            cudf_table_view.table_view table_,
        ) except+
        unique_ptr[vector[uint8_t]] close(
            string column_chunks_file_path,
        ) except+

    cdef unique_ptr[vector[uint8_t]] merge_rowgroup_metadata(
        const vector[unique_ptr[vector[uint8_t]]]& metadata_list
    ) except +
