
include(TargetMacros)

set(CCSD_T_SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}/cc/ccsd_t)
set(CCSD_T_SRCS
    ${CCSD_T_SRCDIR}/memory.cpp
    ${CCSD_T_SRCDIR}/ccsd_t_common.hpp
    ${CCSD_T_SRCDIR}/hybrid.cpp
    ${CCSD_T_SRCDIR}/ccsd_t_unfused_driver.hpp
    ${CCSD_T_SRCDIR}/ccsd_t_singles_unfused_cpu.hpp
    ${CCSD_T_SRCDIR}/ccsd_t_doubles_unfused_cpu.hpp
    ${CCSD_T_SRCDIR}/sd_t_total_cpu.cpp
    ${CCSD_T_SRCDIR}/ccsd_t_fused_driver.hpp
    ${CCSD_T_SRCDIR}/fused_common.hpp
    )

if(USE_CUDA)
    set(CCSD_T_UNFUSED_SRCS ${CCSD_T_SRCS}
            ${CCSD_T_SRCDIR}/sd_t_total_gpu.cu
            ${CCSD_T_SRCDIR}/sd_t_total_nwc.cu
            ${CCSD_T_SRCDIR}/ccsd_t_singles_unfused.hpp
            ${CCSD_T_SRCDIR}/ccsd_t_doubles_unfused.hpp)

    set(CCSD_T_FUSED_SRCS ${CCSD_T_SRCS}
            ${CCSD_T_SRCDIR}/ccsd_t_all_fused.hpp
            ${CCSD_T_SRCDIR}/ccsd_t_all_fused_gpu.cu
            ${CCSD_T_SRCDIR}/ccsd_t_all_fused_nontcCuda_Hip_Sycl.cpp)

    set_source_files_properties(${CCSD_T_SRCDIR}/ccsd_t_all_fused_nontcCuda_Hip_Sycl.cpp PROPERTIES LANGUAGE CUDA)
elseif(USE_HIP)
    set(CCSD_T_FUSED_SRCS ${CCSD_T_SRCS}
            ${CCSD_T_SRCDIR}/ccsd_t_all_fused.hpp
            ${CCSD_T_SRCDIR}/ccsd_t_all_fused_nontcCuda_Hip_Sycl.cpp)

elseif(USE_DPCPP)
    set(CCSD_T_FUSED_SRCS ${CCSD_T_SRCS}
            ${CCSD_T_SRCDIR}/ccsd_t_all_fused.hpp
            ${CCSD_T_SRCDIR}/ccsd_t_all_fused_nontcCuda_Hip_Sycl.cpp)
else()
    set(CCSD_T_UNFUSED_SRCS ${CCSD_T_SRCS})
    set(CCSD_T_FUSED_SRCS ${CCSD_T_SRCS}
            ${CCSD_T_SRCDIR}/ccsd_t_all_fused_cpu.hpp)
endif()

add_mpi_cuda_unit_test(CCSD_T "${CCSD_T_FUSED_SRCS}" 2 "${CMAKE_SOURCE_DIR}/../inputs/h2o.json")
#add_mpi_cuda_unit_test(CCSD_T_Old "${CCSD_T_UNFUSED_SRCS}" 2 "${CMAKE_SOURCE_DIR}/../inputs/h2o.json")

